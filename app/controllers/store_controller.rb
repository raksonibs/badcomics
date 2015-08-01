class StoreController < ApplicationController
  def index
    @registration = Registration.new
    @products = Product.all
  end

  def create
    @registration = Registration.new registration_params.merge(email: stripe_params["stripeEmail"],
                                                               card_token: stripe_params["stripeToken"])
    raise "Please, check registration errors" unless @registration.valid?
    @registration.process_payment
    @registration.save
    redirect_to @registration, notice: 'Registration was successfully created.'
  rescue e
    flash[:error] = e.message
    render :new
  end

  def add_to_cart
    @cart = Cart.find(params[:cart_id])    
    @product = Product.find(params[:product_id])    
    @cart.products << @product  
    respond_to do |format|
      format.js{ render 'add_to_cart', locals: { :@cart => @cart } }
    end
  end

  private
  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end
end
