class AddDayEndForEvents < ActiveRecord::Migration
  def change
    add_column :events, :day_end, :string
    rename_column :events, :time, :day_on
    rename_column :events, :link, :url
    remove_column :events, :feeling
  end
end
