class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :recruit
      t.float :percent
      t.string :distinction
      t.timestamps null: false
    end
  end
end
