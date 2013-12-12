class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :price
      t.string :category
      t.string :feeling

      t.timestamps
    end
  end
end
