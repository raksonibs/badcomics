class PublishAndOrdertoImages < ActiveRecord::Migration
  def change
    add_column :images, :order, :integer
    add_column :images, :published, :boolean, :default => false
  end
end
