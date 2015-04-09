class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      session[:user_id] = nil
      session[:pre_2fa_auth_user_id] = @user.id
      Authy::API.request_sms(id: @user.authy_id)
      redirect_to sessions_two_factor_path
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def two_factor
    return redirect_to new_session_path unless session[:pre_2fa_auth_user_id]
  end

  def verify
    @user = User.find(session[:pre_2fa_auth_user_id])
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])
    if token.ok?
      session[:user_id] = @user.id
      @current_user = User.find(@user.id)
      session[:pre_2fa_auth_user_id] = nil
      redirect_to home_path(@current_user.id)
    else
      flash.now[:danger] = "Incorrect code, please try again"
      render :two_factor
    end
  end

  def resend
    @user = User.find(session[:pre_2fa_auth_user_id])
    Authy::API.request_sms(id: @user.authy_id)
    flash[:notice] = "Verification code re-sent"
    redirect_to sessions_two_factor_path
  end

  def destroy
    logout
    redirect_to(:root, notice: 'Logged out!')
  end
end
