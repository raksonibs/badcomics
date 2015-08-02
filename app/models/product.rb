class Product < ActiveRecord::Base
  has_and_belongs_to_many :cart
  has_attached_file :product_image
  validates_attachment_content_type :product_image, :content_type => /\Aimage\/.*\Z/
end
