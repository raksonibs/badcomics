class AttachmentForProduct < ActiveRecord::Migration
  def change
    remove_column :products, :product_image_file_name
    remove_column :products, :product_image_content_type
    remove_column :products, :product_image_file_size
    remove_column :products, :product_image_updated_at
    add_attachment :products, :product_image
  end
end
