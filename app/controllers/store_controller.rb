class StoreController < ApplicationController
  def index
    @registration = Registration.new
    @products = Product.all
  end

  def create_customer
    @registration = Registration.new registration_params.merge(email: stripe_params["stripeEmail"],
                                                               card_token: stripe_params["stripeToken"])
    raise "Please, check registration errors" unless @registration.valid?
    binding.pry
    @registration.process_payment
    @registration.save
    redirect_to @registration, notice: 'Registration was successfully created.'
  rescue e
    flash[:error] = e.message
    render :new
  end

  def test
  end

  def checkout
    respond_to do |format|
      format.js
    end
  end

  def add_to_cart
    @cart = Cart.find(params[:cart_id])    
    @product = Product.find(params[:product_id])    
    @cart.products << @product
    respond_to do |format|
      format.json
    end
  end

  private
  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end
end
