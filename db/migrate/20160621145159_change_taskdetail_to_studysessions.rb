class ChangeTaskdetailToStudysessions < ActiveRecord::Migration
  def up
  	change_column :studysessions, :task, :string, default: "todo"
  	change_column :studysessions, :repeat, :string, default: true
  end

  def down
  	change_column :studysessions, :task, :string
  	change_column :studysessions, :repeat, :string
  end
end
