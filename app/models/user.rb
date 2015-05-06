class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :images, :dependent => :destroy

  def self.adminUser
    User.find_by_email('thisbetterbeacompliment@badcomics.ca')
  end

  def self.allPublishedImages
    User.adminUser.images.where(published: true).order(:order)
  end

  def self.latestImage
    User.adminUser.images.where(published: true).order(:order).last 
  end

  def self.firstImage
    User.adminUser.images.where(published: true).order(:order).first
  end

  def self.nextImage(image)
    imageArray = User.adminUser.images.where(published: true).order(:order)
    thisIndex = (imageArray.map.with_index.to_a).to_h[image]    
    return image if thisIndex >= imageArray.length - 1     
    nextImage = imageArray[thisIndex + 1] 
  end

  def self.prevImage(image)
    imageArray = User.adminUser.images.where(published: true).order(:order)
    thisIndex = (imageArray.map.with_index.to_a).to_h[image]    
    return image if thisIndex == 0    
    nextImage = imageArray[thisIndex - 1] 
  end
end
