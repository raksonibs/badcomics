class AddShippingColumnsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :address, :string
  end
end
