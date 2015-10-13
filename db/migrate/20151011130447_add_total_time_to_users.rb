class AddTotalTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_time, :integer
  end
end
