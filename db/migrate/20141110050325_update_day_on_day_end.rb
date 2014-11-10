class UpdateDayOnDayEnd < ActiveRecord::Migration
  def change
    rename_column :events, :category, :categoryList
    rename_column :events, :day_end, :dayEnd
    rename_column :events, :day_on, :dayOn
  end
end
