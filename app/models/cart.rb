class Cart < ActiveRecord::Base
  belongs_to :registration
  has_many :products
end
