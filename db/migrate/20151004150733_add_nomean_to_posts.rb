class AddNomeanToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :nomean, :string
  end
end
