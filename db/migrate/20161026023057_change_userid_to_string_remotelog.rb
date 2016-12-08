class ChangeUseridToStringRemotelog < ActiveRecord::Migration
  def up
  	change_column :remotelogs, :userid, :string

  end
  def down 
  	change_column :remotelogs, :userid, :integer
  end
end
