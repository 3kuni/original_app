class ChangeUseridToRemotelog < ActiveRecord::Migration
  def up
  	change_column :remotelogs, :userid, :integer

  end
  def down 
  	change_column :remotelogs, :userid, :string
  end
end
