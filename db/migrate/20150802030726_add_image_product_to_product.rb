class AddImageProductToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_image_file_name, :string
    add_column :products, :product_image_content_type, :string
    add_column :products, :product_image_file_size, :integer
    add_column :products, :product_image_updated_at, :datetime
  end
end
