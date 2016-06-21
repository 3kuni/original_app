class ChangeTaskToStudysessions < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :studysessions, :due, :datetime
  end

  # 変更前の状態
  def down
    change_column :studysessions, :due, :date
  end
end
