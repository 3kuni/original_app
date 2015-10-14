class RenameHoursTotalColomnToRooms < ActiveRecord::Migration
  def change
    rename_column :rooms, :hours_total, :minutes_total
  end
end
