class SessionsController < ApplicationController
  def new
  end
  
  # Creates a new session for the user by authenticating name and password.
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
	  if userIsInitialized(user)
	    redirect_to articles_path, :notice => "Logged in!"
	  else
	    redirect_to pretest_path
	  end
    else
      flash.now.alert = "Invalid username or password"
      render 'new'
    end
  end

  # called when logging out. Destroys the session.
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
  
    # Returns a boolean whether user model is initialized.
	
  def userIsInitialized(user)
    @kvectors = Kvector.find(:all, 
	  :conditions => ['user.id = kvector.user_id'],
	  :joins => [:user])
	if @kvectors.length == 0
	  return false
	else
	  return true
	end
  end
  
end
