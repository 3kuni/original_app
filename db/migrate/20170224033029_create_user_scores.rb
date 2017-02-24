class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.string :uuid, null:false
      t.string :year, null: false
      t.integer :japanese
      t.integer :english
      t.integer :math
      t.integer :social
      t.integer :science
      t.integer :total
      t.string :school
      t.integer :school_id
      t.timestamps null: false
    end
  end
end
