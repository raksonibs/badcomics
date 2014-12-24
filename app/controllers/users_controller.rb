class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user_params])
    @user.password = params[:password]
    @user.save!
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
