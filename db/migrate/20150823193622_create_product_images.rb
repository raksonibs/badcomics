class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.string   "store_image_file_name"
      t.string   "store_image_content_type"
      t.integer  "store_image_file_size"
      t.datetime "store_image_updated_at"
      t.timestamps null: false
      t.integer  "product_id"
    end

    remove_column :products, :product_image_file_name, :string
    remove_column :products, :product_image_content_type, :string
    remove_column :products, :product_image_file_size, :integer
    remove_column :products, :product_image_updated_at, :datetime
  end
end
