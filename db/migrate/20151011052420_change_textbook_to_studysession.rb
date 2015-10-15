class ChangeTextbookToStudysession < ActiveRecord::Migration
    #変更後の型
  def up
    change_column :studysessions, :textbook, :string
  end

  #変更前の型
  def down
    change_column :studysessions, :textbook, :intger
  end
end
