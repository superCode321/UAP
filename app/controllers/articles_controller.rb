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

  # displays all articles in ranked order
  def index
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

  # Higher score means harder article
  def scoreArticle(article)
  	score = 0
  	@user = current_user
  	if article.body == nil or article.body == ''
  		return 1
  	end

    body = article.body.split(//)
    body = body.uniq
    for char in body
      	@word = Word.find_by_text(char)
      	if @word != nil and @word.id != nil
	      kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
	      	@user.id, @word.id])
	      if kvector == nil or kvector.is_known == false
	      	score += 1
	      end
	    else
	      # if isChinese(char)
	      #   score += 1
	      # end
	    end
	end
	return score
  end
  
  def rankArticles(articles)
  	rankList = []
  	for article in articles
  		tuple = [article, scoreArticle(article)]
  		rankList.push(tuple)
  	end
  	return rankList
  end

  def show
	@article = Article.find(params[:id])
  @test_body = ['a','b','c']#on_show(@article)
	flash[:notice] = "Words updated on article show"
	@displayBody = build_show_view(@article)

	respond_to do |format|
	  format.html # show.html.erb
	  format.json { render json: @article }
	end
  end

  # FOR NOW: Only displays registered words.
  def build_show_view(article)
  	new_body = ''
  	@user = current_user
    if article.body == nil or article.body == ''
    	return ''
    end
	body = article.body.split(//)
    body = body.uniq
    for char in body
    	@word = Word.find_by_text(char)
    	if @word != nil and @word.id != nil
			new_body << char
		end
    end
    return new_body
  end

  # Word set to unknown on word click
  def on_click
  	char = params[:char]
    @user = current_user
    @word = Word.find_by_text(char)
  	if @word != nil and @word.id != nil
      kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
      	@user.id, @word.id])
      kvector.is_known = false
      kvector.save
    end
  end

  # Displays list of unique chinese chars
  # View count updates on article display
  def on_show(article)
  	new_body = []
    @user = current_user
    if article.body == nil or article.body == ''
    	return
    end

    body = article.body.split(//)
    body = body.uniq
    for char in body
    	@word = Word.find_by_text(char)
    	if @word != nil and @word.id != nil
    		new_body.push(char)
	    	@kvector = Kvector.find(:first, :conditions => ["user_id = ? AND word_id = ?",
	    		@user.id, @word.id])
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
  def isChinese(char)
  	ch = char.unpack('U*')[0]
    if ch >= 0x4E00 && ch <= 0x9FFF
    	return true
    else
    	return false
    end
  end


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
