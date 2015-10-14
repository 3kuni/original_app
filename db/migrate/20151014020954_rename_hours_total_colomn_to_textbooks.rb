class RenameHoursTotalColomnToTextbooks < ActiveRecord::Migration
  def change
        rename_column :textbooks, :hours_total, :minutes_total
  end
end
