class AddComicsColumnToUserReallyThough < ActiveRecord::Migration
 def self.up
    add_attachment :users, :comic
  end

  def self.down
    remove_attachment :users, :comic
  end
end
