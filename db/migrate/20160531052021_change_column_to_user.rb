class ChangeColumnToUser < ActiveRecord::Migration
    # 変更内容
  def up
    change_column :users, :starpoint, :integer,  default: 0
  end

  # 変更前の状態
  def down
    change_column :users, :starpoint, :integer
  end
end
