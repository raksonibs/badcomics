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
      format.json{ render json: { good: 'good' }, status: 200 }
    end
  rescue e
    respond_to do |format|
      format.json{ render json: @registration.errors, status: :unprocessable_entity }
    end
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
    @products = @cart.products
    respond_to do |format|
      format.json
    end
  end

  private
  def registration_params
    params.permit :email, :token, :cart_id, :price, :billing_address_city, :billing_address_country, :billing_address_country_code, :billing_address_line1, :billing_address_zip, :billing_name, :shipping_address_city, :shipping_address_country, :shipping_address_country_code, :shipping_address_line1, :shipping_address_zip, :shipping_name
  end
end
