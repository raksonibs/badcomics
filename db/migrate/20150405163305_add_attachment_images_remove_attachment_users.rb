class AddAttachmentImagesRemoveAttachmentUsers < ActiveRecord::Migration
  def change
    add_attachment :images, :comic
    remove_attachment :users, :comic
  end
end
