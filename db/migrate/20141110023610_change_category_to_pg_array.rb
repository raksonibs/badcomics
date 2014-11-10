class ChangeCategoryToPgArray < ActiveRecord::Migration
  def change
    remove_column :events, :category
  end
end
