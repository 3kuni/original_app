class AddTweetToStudysessions < ActiveRecord::Migration
  def change
    add_column :studysessions, :tweet, :string
  end
end
