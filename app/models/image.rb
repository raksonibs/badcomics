class Image < ActiveRecord::Base
  has_attached_file :comic
  validates_attachment_content_type :comic, :content_type => /\Aimage\/.*\Z/

  belongs_to :user

  def lastOrder
    Image.sort(:order).last.order
  end
end
