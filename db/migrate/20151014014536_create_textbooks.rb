class CreateTextbooks < ActiveRecord::Migration
  def change
    create_table :textbooks do |t|
      t.string :title
      t.string :asin
      t.integer :hours_total
      t.integer :students_total

      t.timestamps null: false
    end
  end
end
