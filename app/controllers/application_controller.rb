class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :require_login

  helper_method :current_user, :current_cart
  helper_method :signed_in?

  before_filter :set_subscriber

  def current_cart
    @current_cart ||= Cart.find_by_id(session[:cart])
    return @current_cart if @current_cart
    Cart.new({name: 'New Cart'}).save
    session[:cart] = Cart.last.id
    @current_cart = Cart.last
  end

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

  def set_subscriber
    @subscriber = Subscriber.new
  end

end
