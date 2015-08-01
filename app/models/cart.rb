class Cart < ActiveRecord::Base
  belongs_to :registration
  has_and_belongs_to_many :products
end
