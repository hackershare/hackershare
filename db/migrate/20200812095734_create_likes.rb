class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user
      t.references :bookmark
      t.timestamps
      t.index %i[user_id bookmark_id], unique: true
    end
    add_column :bookmarks, :likes_count, :integer, default: 0
    add_column :bookmarks, :like_user_ids, :integer, array: true, default: "{}"
  end
end
