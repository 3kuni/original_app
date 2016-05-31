class AddPointToStudysessions < ActiveRecord::Migration
  def change
    add_column :studysessions, :starpoint, :integer
  end
end
