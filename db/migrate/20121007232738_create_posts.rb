class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :content
      t.integer :tag_id
      t.integer :author_id

      t.timestamps
    end
  end
end
