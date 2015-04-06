class UsersController < ApplicationController
  skip_before_filter :require_login, except: [:home]

  def new
    @user = User.new
  end

  def normal
  end

  def home
    @user = current_user
  end

  def create
    @user = User.new(params[:user_params])
    @user.password = params[:password]

    if params[:user][:name] == Figaro.env.username && params[:user][:password] == Figaro.env.password
      if @user.save
        session[:user] = @user.id
        redirect_to root_url
      else
        render :new
      end
    else
      @user.errors.add(:password, 'Either username or password is incorrect')
      render :new
    end
  end

  def loginPage
  end

  def login
    @user = User.find_by_name(params[:name])
    if @user.password == params[:password]
      give_token
    else
      redirect_to home_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
