class UsersController < ApplicationController
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

  def initializeUser(difficulty)
    words = Word.find(:all, :conditions => ["difficulty <= ?",difficulty])
	@kvectors = []
	for word in words
	  @kvector = Kvector.new
	  @kvector.word = word
	  @kvector.is_known = 1
	  @kvector.view_count = 0
	  @kvector.save
	  @kvectors.push(@kvector)
	  @kvectors.save
	end
	@user.kvectors = kvectors
	@user.save
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
