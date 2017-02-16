class CreateWcusers < ActiveRecord::Migration
  def change
    create_table :wcusers do |t|
      t.string :token
      t.boolean :premium

      t.timestamps null: false
    end
  end
end
