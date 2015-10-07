class CreateStudysessions < ActiveRecord::Migration
  def change
    create_table :studysessions do |t|
      t.integer :user
      t.integer :textbook
      t.timestamp :start
      t.timestamp :finish
      t.integer :time
      t.integer :starred
      t.boolean :active

      t.timestamps
    end
  end
end
