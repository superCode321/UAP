require 'open-uri'
require 'nokogiri'

class ArticlesController < ApplicationController
  before_filter :require_login
  
  def require_login
    unless !!current_user
		flash[:error] = "Need to be logged in."
		redirect_to log_in_path
	  end
  end
  
  def new
    @article = Article.new
  end
	
	
  def create
  	@article = Article.new(params[:article])
  	@article.save
  	if @article.save
  	  redirect_to articles_path, :notice => "Article created"
  	else
  	  render "new"
  	end
  end


  def addArticle
    # Count param represents number of articles
    # i is the index of the article to fetch
    i = Article.article_index# %250 # cycles back after 250 articles
    result = fetchArticle(i)
    body = result[1]
    while body == nil or body.length < 10
      i += 1
      result = fetchArticle(i)
      body = result[1]
    end
    Article.changeIndex(i)
    title = result[0]
    source_url = result[2]
    #if Article.find_by_title(:conditions => ["title = ?",title]) == nil
      @article = Article.new(:title => title, :body => body, :source_url => source_url)
      @article.save
    #end
    if @article.save
      flash[:notice] = "Article added!"
    end
    redirect_to articles_path
  end

  # Get new articles by url
  # NOTE: Can change url to different rss feed
  def fetchArticle(i)
    # RSS source: news.google.com (Taiwan version)
    feed = "https://news.google.com/news/feeds?pz=1&cf=all&ned=tw&hl=zh-TW&output=rss"
    result = []
    bodyStr = ""
    rss = SimpleRSS.parse open(feed)
    #for i in 0...5#d.entries.length
      title = rss.entries[i].title
      source_url = rss.entries[i].link
      source_url = source_url.split("url=").last
      doc = Nokogiri::HTML.parse(open(source_url))
      #body_text = []
      #line = doc.gets
      #while line
        #if line.start_with?("<p>")
        #end
        #line = doc.gets
      doc.search('p').each do |line|
        bodyStr << line.text
      end

      # for p in body_text
      #   bodyStr << p
      #   #bodyStr << '\n'
      # end

      #doc.close()
      #break
    #end
    result.push(title)
    result.push(bodyStr)
    result.push(source_url)
    return result
  end


  # displays all articles in ranked order
  def index
    @index = Article.article_index
  	@user = current_user
  	@articles = Article.find(:all)
  	# Rank by score, or the second index
  	@rankList = rankArticles(@articles).sort_by {|e| [e[1]]}

  	@known_vecs = []
  	for vec in @user.kvectors
  		if vec != nil and vec.is_known == true
  			@known_vecs.push(vec)
  		end
  	end
  	respond_to do |format|
  	  format.html # index.html.erb
  	  format.json { render json: @articles }
  	end
  end

  # def efficientScoreArticle(article)
  #   score = 0
  #   @user = current_user
  #   if article.body == nil or article.body == ''
  #     return 1
  #   end
  #   body = article.body.split(//)
  #   body = body.uniq
  #   for char in body
  #     if @user.knowledge_string.index(char) != nil
  #       score += 1
  #     end
  #   end

  #   return score
  # end



  # Higher score means harder article
  def scoreArticle(article)
  	score = 0
  	@user = current_user
  	if article.body == nil or article.body == ''
  		return 1
  	end

    body = article.body.split(//)
    body = body.uniq
    for char in body # KEY: Linear search
    	@word = Word.find_by_text(char) # KEY: Linear search
    	if @word != nil and @word.id != nil
        kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
      	  @user.id, @word.id]) # KEY: Linear search
	      if kvector == nil or kvector.is_known == false
	      	score += 1
	      end 
      end
	  end

    # karticle = Karticle.find(:first, :conditions => ["article_id = ?", article.id])
    # karticle.score = score
    # karticle.save

	  return score
  end
  
  # Called on display of article list
  def rankArticles(articles)
  	rankList = []
  	for article in articles
      #karticle = Karticle.find(:first, :conditions => ["article_id = ? ", article.id])
      #if karticle != nil
    		tuple = [article, scoreArticle(article)]#karticle.score]
    		rankList.push(tuple)
      #end
  	end
  	return rankList
  end

  def show
  	@article = Article.find(params[:id])
    @new_body = on_show(@article)
  	#flash[:notice] = "Words updated on article show!"

  	respond_to do |format|
  	  format.html # show.html.erb
  	  format.json { render json: @article }
      format.json { render json: @new_body }
  	end
  end

  # Word set to unknown on word click
  def on_click
    char = params[:char]
    charList = char.split(//)
    if charList.length == 1
      single_on_click(char)
    else
      for char in charList
        single_on_click(char)
      end
    end 

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def single_on_click(char)
    @user = current_user
    @word = Word.find_by_text(char) # KEY: Linear search
  	if @word != nil and @word.id != nil
      @kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
      	@user.id, @word.id]) # KEY: Linear search
      @kvector.is_known = false
      @kvector.view_count = 0
      @kvector.save
    end
  end

  # Displays list of unique chinese chars
  # View count updates on article display
  # Only deals with characters from HSK (lvl 1-6)

  # Updates article score
  def on_show(article)
  	new_body = ""
    @user = current_user
    if article.body == nil or article.body == ''
    	return
    end

    body = article.body.split(//)
    body = body.uniq
    for char in body # KEY: Linear in article text size
    	@word = Word.find_by_text(char) #KEY: Linear in word table
      # Word is one of the basic 2631 words.
    	if @word != nil and @word.id != nil
    		new_body << char
	    	@kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
	    		@user.id, @word.id]) # KEY: Linear in kvector table
	    	if @kvector != nil
	    		@kvector.view_count += 1
	    		@kvector.save
	    	else # See for the first time
	    		@kvector = Kvector.create(:user_id => @user.id, :word_id => @word.id,
	    			:is_known => false, :view_count => 1)
	    		@kvector.save
	    	end
    		# If has been seen 3 or more times, set to known.
    		if @kvector.view_count >= 3
    			@kvector.is_known = true
    			@kvector.view_count = 0
    			@kvector.save
    		end
	    # else # An unregistered word
	    # 	@word = Word.create(:text => char, :difficulty => 6)
	    # 	@word.save
	    # 	@kvector = Kvector.create(:user_id => @user.id, :word_id => @word.id,
	    # 			:is_known => false, :view_count => 1)
	    # 	@kvector.save
	    end
	  end

	  return new_body
  end

  # Determines whether char is Chinese
  # def isChinese(char)
  # 	ch = char.unpack('U*')[0]
  #   if ch >= 0x4E00 and ch <= 0x9FFF
  #   	return true
  #   else
  #   	return false
  #   end
  # end


  def edit
	  @article = Article.find(params[:id])
  end

  def update
	  @article = Article.find(params[:id])

  	respond_to do |format|
  	  if @article.update_attributes(params[:article])
  		format.html { redirect_to @article, notice: 'Article was successfully updated.' }
  		format.json { head :no_content }
  	  else
  		format.html { render action: "edit" }
  		format.json { render json: @article.errors, status: :unprocessable_entity }
  	  end
  	end
  end

  def destroy
  	@article = Article.find(params[:id])
  	@article.destroy

  	respond_to do |format|
  		format.html { redirect_to articles_path }
  		format.json { head :no_content }
  	end
  end

end
