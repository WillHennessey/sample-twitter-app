class EditPostModel < ActiveRecord::Migration
  def change
    remove_column :posts, :title
    add_index :posts, [:user_id, :created_at]
  end
end
