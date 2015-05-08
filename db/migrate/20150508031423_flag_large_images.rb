class FlagLargeImages < ActiveRecord::Migration
  def change
    add_column :images, :large_img, :boolean, :default => false
  end
end
