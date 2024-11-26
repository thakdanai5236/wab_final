class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :titel
      t.string :description
      t.string :keywords

      t.timestamps
    end
  end
end
