class AddTimesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :times, :integer
  end
end
