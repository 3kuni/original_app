class ChangeNomeanToPosts < ActiveRecord::Migration
  #変更後の型
  def up
    change_column :Posts, :nomean, :boolean
  end

  #変更前の型
  def down
    change_column :Posts, :nomean, :string
  end
end
