class Image < ActiveRecord::Base
  has_attached_file :comic
  validates_attachment_content_type :comic, :content_type => /\Aimage\/.*\Z/

  belongs_to :user

  include FriendlyId

  friendly_id :title

  def is_first?
    order == Image.all.where(published: true).order(:order).last.order
  end

  def is_last?
    order == Image.all.where(published: true).order(:order).first.order
  end

  def lastOrder
    Image.sort(:order).last.order
  end
end
