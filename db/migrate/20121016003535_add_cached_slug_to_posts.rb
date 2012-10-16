class AddCachedSlugToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :cached_slug, :text
    add_index :posts, :cached_slug
  end
end
