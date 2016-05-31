class AddPointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :starpoint, :integer
  end
end
