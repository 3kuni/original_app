class CreateUserAnswers < ActiveRecord::Migration
  def change
    create_table :user_answers do |t|
      t.string :uuid, null:false
      t.string :year, null: false
      t.string :subject, null: false
      t.integer :number, null: false
      t.string :category1
      t.string :category2
      t.string :category3
      t.string :category4
      t.string :user_answer
      t.integer :point
      t.integer :total_point
      t.timestamps null: false
    end
  end
end
