class CreateRemotelogs < ActiveRecord::Migration
  def change
    create_table :remotelogs do |t|
      t.integer :wordid
      t.string :fromto
      t.boolean :correct
      t.float :time

      t.timestamps null: false
    end
  end
end
