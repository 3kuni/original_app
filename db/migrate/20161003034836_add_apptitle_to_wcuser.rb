class AddApptitleToWcuser < ActiveRecord::Migration
  def change
  	add_column :wcusers, :apptitle, :string
  end
end
