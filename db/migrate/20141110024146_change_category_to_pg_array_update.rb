class ChangeCategoryToPgArrayUpdate < ActiveRecord::Migration
  def change
    add_column :events, :category, :string, :array => true, default: []
  end
end
