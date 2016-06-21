class AddTaskcolumnToStudysessions < ActiveRecord::Migration
  def change
    add_column :studysessions, :due, :date
    add_column :studysessions, :repeat, :string
    add_column :studysessions, :task, :string
    add_column :studysessions, :pomo, :string
  end
end
