class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
