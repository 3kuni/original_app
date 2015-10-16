class AddWordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :word, :string
  end
end
