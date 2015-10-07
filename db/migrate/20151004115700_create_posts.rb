class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :article
      t.string :author
      t.string :nomean

      t.timestamps
    end
  end
end
