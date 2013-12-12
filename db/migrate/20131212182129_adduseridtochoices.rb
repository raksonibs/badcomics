class Adduseridtochoices < ActiveRecord::Migration
  def change
  	add_column :choices, :user_id, :integer
  end
end
