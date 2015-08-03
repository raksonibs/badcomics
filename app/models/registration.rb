class Registration < ActiveRecord::Base
  has_one :cart
  def process_payment
    customer = Stripe::Customer.create email: email,
                                       card: token

    cart = self.cart

    description = cart.products.map(&:name).join(" -  ")
    price = self.price

    Stripe::Charge.create customer: customer.id,
                          amount: price.round * 100,
                          description: description,
                          currency: 'usd'

  end
end
