class AddRoomToStudysession < ActiveRecord::Migration
  def change
    add_column :studysessions, :room, :integer
  end
end
