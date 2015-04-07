class SessionsController < ApplicationController
<<<<<<< HEAD
	def create
	  auth = request.env["omniauth.auth"]
	  #gets env
	  user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
	  session[:user_id] = user.id
	  # FbGraph::User.me(user.oauth_token).fetch
	  redirect_to "/", :notice => "Signed in!"
	end

	def destroy
  		session[:user_id] = nil
  		redirect_to "/", :notice => "Signed out!"
	end
=======
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:root_url, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root_url, notice: 'Logged out!')
  end
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
end
