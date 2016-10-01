class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :jaword
      t.string :enword
      t.float :jepercent
      t.float :ejpercent

      t.timestamps null: false
    end
  end
end
