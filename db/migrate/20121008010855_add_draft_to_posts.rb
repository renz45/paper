class AddDraftToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :draft, :boolean, default: true
    add_index :posts, :draft
  end
end
