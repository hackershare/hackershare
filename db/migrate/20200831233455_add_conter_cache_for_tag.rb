class AddConterCacheForTag < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :tags_count, :integer, default: 0
    add_column :users, :tags_count, :integer, default: 0
    add_column :users, :taggings_count, :integer, default: 0
    add_column :tags, :bookmarks_count, :integer, default: 0
  end
end
