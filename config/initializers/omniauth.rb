Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, "490186127763039", "712c85f9b75e8728d6a49ba7d22454e3"
end