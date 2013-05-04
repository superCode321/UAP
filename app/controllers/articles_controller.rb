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

  # displays all articles
  def index
	@article = Article.find(:all) #, :conditions => [])
	respond_to do |format|
	  format.html # index.html.erb
	  format.json { render json: @articles }
	end
  end

  def show
	@article = Article.find(params[:id])
	respond_to do |format|
	  format.html # show.html.erb
	  format.json { render json: @article }
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
