class AddActualShippingColumnsToRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :address
    add_column :registrations,:billing_address_city, :string
    add_column :registrations,:billing_address_country, :string
    add_column :registrations,:billing_address_country_code, :string
    add_column :registrations,:billing_address_line1, :string
    add_column :registrations,:billing_address_zip, :string
    add_column :registrations,:billing_name, :string
    add_column :registrations,:shipping_address_city, :string
    add_column :registrations,:shipping_address_country, :string
    add_column :registrations,:shipping_address_country_code, :string
    add_column :registrations,:shipping_address_line1, :string
    add_column :registrations,:shipping_address_zip, :string
    add_column :registrations,:shipping_name, :string
  end
end
