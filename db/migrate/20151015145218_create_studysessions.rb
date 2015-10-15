class CreateStudysessions < ActiveRecord::Migration
  def change
    create_table :studysessions do |t|
      t.integer  "user"
      t.string   "textbook"
      t.datetime "start"
      t.datetime "finish"
      t.integer  "time"
      t.integer  "starred"
      t.boolean  "active"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "room"
    end
  end
end