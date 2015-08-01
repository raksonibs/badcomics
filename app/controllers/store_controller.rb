class StoreController < ApplicationController
  def index
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

  private
  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end
end
