class SessionsController < ApplicationController
  def new
  end
  
  # Creates a new session for the user by authenticating name and password.
  # Differentiates Shopper and Keeper states and displays a persistent notification.
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
	  redirect_to articles_path, :notice => "Logged in!"
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
end
