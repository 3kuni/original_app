class CreateCorrectAnswers < ActiveRecord::Migration
  def change
    create_table :correct_answers do |t|
      t.string :year, null: false
      t.string :subject, null: false
      t.integer :number, null: false
      t.string :category1
      t.string :category2
      t.string :category3
      t.string :category4
      t.string :correctAnswer
      t.string :image
      t.integer :point
      t.timestamps null: false
    end
  end
end
