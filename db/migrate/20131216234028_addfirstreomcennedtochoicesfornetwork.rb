class Addfirstreomcennedtochoicesfornetwork < ActiveRecord::Migration
  def change
  	add_column :choices, :first_event, :name
  end
end
