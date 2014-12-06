class AddImageAndSourceToEvent < ActiveRecord::Migration
  def change
    add_column :events, :image, :string
    add_column :events, :source, :string
  end
end
