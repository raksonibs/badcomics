class RemovePasswordandPasswordConffreomUsersAndAddPasswordDigest < ActiveRecord::Migration
  def change
    remove_column :users, :password
    remove_column :users, :password_hash
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    add_column :users, :string, :password_digest
  end
end
