class AddRemotelogToUserid < ActiveRecord::Migration
  def change
  	add_column :remotelogs, :userid, :string 
  end
end
