class AddPriceToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :price, :float
  end
end
