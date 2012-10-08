class AddProcessedContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :processed_content, :text
  end
end
