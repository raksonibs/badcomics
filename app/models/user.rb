class User < ActiveRecord::Base
<<<<<<< HEAD
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
=======
  authenticates_with_sorcery!
  has_many :images, :dependent => :destroy

  def self.adminUser
    User.find_by_email('thisbetterbeacompliment@badcomics.ca')
  end

  def self.allImages
    User.adminUser.images
  end

  def self.latestImage
    User.adminUser.images.last 
  end

  def self.firstImage
    User.adminUser.images.first
  end

  def self.nextImage(image)
    imageArray = User.adminUser.images
    thisIndex = (imageArray.map.with_index.to_a).to_h[image]    
    return image if thisIndex >= imageArray.length - 1     
    nextImage = imageArray[thisIndex + 1] 
  end

  def self.prevImage(image)
    imageArray = User.adminUser.images
    thisIndex = (imageArray.map.with_index.to_a).to_h[image]    
    return image if thisIndex == 0    
    nextImage = imageArray[thisIndex - 1] 
  end
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
end
