class ProductImage < ActiveRecord::Base
  has_attached_file :store_image
  validates_attachment_content_type :store_image, :content_type => /\Aimage\/.*\Z/
end
