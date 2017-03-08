class Rename < ActiveRecord::Migration
  def change
    rename_column :posts, :context, :content
  end
end
