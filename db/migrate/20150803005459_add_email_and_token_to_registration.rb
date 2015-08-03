class AddEmailAndTokenToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :email, :string
    add_column :registrations, :token, :string
    remove_column :registrations, :name
    remove_column :registrations, :card_token
  end
end
