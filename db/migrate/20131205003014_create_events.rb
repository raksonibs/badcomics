class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :price
      t.string :location
      t.string :category
      t.string :feeling
      t.string :time

      t.timestamps
    end
  end
end
