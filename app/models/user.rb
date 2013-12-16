class User < ActiveRecord::Base
	has_many :choices
	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth["provider"]
	    user.uid = auth["uid"]
	    user.name = auth["info"]["name"]
	    user.oauth_token = auth["credentials"]["token"]
    	user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	    
	 #    client.authorization_code = params[:code]
		# access_token = client.access_token! :client_auth_body # => Rack::OAuth2::AccessToken
		# FbGraph::User.me(access_token).fetch
	  end
  	end
end
