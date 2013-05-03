class ArticleController < ApplicationController
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
  
  def index
	@items = Item.find(:all, :conditions => ["buyer=?","none"])
	respond_to do |format|
	  format.html # index.html.erb
	  format.json { render json: @items }
	end
  end

  def show
	@item = Item.find(params[:id])
	respond_to do |format|
	  format.html # show.html.erb
	  format.json { render json: @item }
	end
  end
  
  def edit
	@item = Item.find(params[:id])
  end
  
  def destroy
	@item = Item.find(params[:id])
	@item.destroy

	respond_to do |format|
		format.html { redirect_article_path }
		format.json { head :no_content }
	end
  end
  
  def update
	@item = Item.find(params[:id])

	respond_to do |format|
	  if @item.update_attributes(params[:item])
		  format.html { redirect_to article_path, notice: 'Article was successfully updated.' }
		  format.json { head :no_content }
	  else
		format.html { render action: "edit" }
		format.json { render json: @item.errors, status: :unprocessable_entity }
	  end
  end
  
  
end
