Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, Figaro.env.facebook_id, Figaro.env.facebook_secret,
   :scope => 'email,read_stream',
    :client_options => {
      :site => 'https://graph.facebook.com/v2.0',
      :authorize_url => "https://www.facebook.com/v2.0/dialog/oauth"
    }
end