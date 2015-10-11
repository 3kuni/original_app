class ChangeTextbookToStudysession < ActiveRecord::Migration
    #変更後の型
  def up
    change_column :Studysessions, :textbook, :string
  end

  #変更前の型
  def down
    change_column :Studysessions, :textbook, :intger
  end
end
