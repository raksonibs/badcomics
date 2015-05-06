class ShowTitleToComic < ActiveRecord::Migration
  def change
    add_column :images, :show_title, :boolean, :default => false
  end
end
