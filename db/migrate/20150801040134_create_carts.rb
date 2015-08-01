class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :registration_id
      t.timestamps null: false
    end
  end
end
