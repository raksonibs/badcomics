class CartsProductsTable < ActiveRecord::Migration
  def change
    create_table :carts_products do |t|
      t.integer :product_id
      t.integer :cart_id
      t.timestamps null: false
    end
  end
end
