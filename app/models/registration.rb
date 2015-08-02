class Registration < ActiveRecord::Base
  has_one :cart
  def process_payment
    customer = Stripe::Customer.create email: email,
                                       card: card_token
    binding.pry
    Stripe::Charge.create customer: customer.id,
                          amount: product.price * 100,
                          description: product.name,
                          currency: 'usd'

  end
end
