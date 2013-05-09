class UsersController < ApplicationController
  before_filter :require_login, :only => :initializeUser
  
  def require_login
    unless !!current_user
    flash[:error] = "Need to be logged in."
    redirect_to log_in_path
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    else
      render "new"
    end
  end
  
  def pretest
    @user = current_user
  end

  # 
  def initializeUser
    @user = current_user
    if @user != nil
      words = Word.find(:all, :conditions => ["difficulty <= ?",params[:difficulty]])
    	kvs = []
    	for word in words
    	  @kvector = Kvector.new
    	  @kvector.word_id = word.id
    	  @kvector.is_known = true
    	  @kvector.view_count = 0
    	  @kvector.save

    	  kvs.push(@kvector)
    	end
    	@user.kvectors.destroy
      
      @user.kvectors = kvs
    	@user.save

      redirect_to articles_path, :notice => "You have been initialized!"
    end
  end
  
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
