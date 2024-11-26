class RenameTitelToTitleInPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :titel, :title
  end
end
