class StoreController < ApplicationController
  def index
    @registration = Registration.new
    @products = Product.all
  end

  def create_customer
    @registration = Registration.new registration_params.merge(email: params["email"], token: params["token"])

    @registration.cart = current_cart
    
    raise "Please, check registration errors" unless @registration.valid?
    @registration.process_payment
    @registration.save
    respond_to do |format|
      format.js
    end
    # redirect_to store_path, notice: 'Your money is successfully in our bank account.'
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
  def registration_params
    params.permit :email, :token, :cart_id, :price
  end
end
