class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :hours_total
      t.integer :current_students

      t.timestamps null: false
    end
  end
end
