Rails.configuration.stripe = {
    :publishable_key => Figaro.env.stripe_key,
    :secret_key      => Figaro.env.stripe_secret
}

Stripe.api_key = Figaro.env.stripe_secret