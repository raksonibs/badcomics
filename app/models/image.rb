class Image < ActiveRecord::Base
  has_attached_file :comic, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :comic, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
end
