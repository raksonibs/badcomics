class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :require_login

  helper_method :current_user
  helper_method :signed_in?

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      @current_user = nil
    end
  end

  def signed_in?
    current_user
    @current_user.present? 
  end

  protected

  def authenticate!
    redirect_to new_session_path and return unless signed_in?
  end

end
