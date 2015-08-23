class Product < ActiveRecord::Base
  has_and_belongs_to_many :cart
  has_many :product_images, :dependent => :destroy
end
