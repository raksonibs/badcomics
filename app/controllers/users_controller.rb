class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def home
  end

  def create
    @user = User.new(params[:user_params])
    @user.password = params[:password]

    if params[:user][:name] == Figaro.env.username && params[:user][:password] == Figaro.env.password
      if @user.save
        session[:user] = @user
        redirect_to root_url
      else
        render :new
      end
    else
      @user.errors.add(:password, 'Either username or password is incorrect')
      render :new
    end
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
      params.require('user').permit([:name, :password])
    end
end
