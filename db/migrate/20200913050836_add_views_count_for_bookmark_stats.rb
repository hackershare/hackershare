class AddViewsCountForBookmarkStats < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmark_stats, :clicks_count, :integer, default: 0
    add_column :bookmarks, :clicks_count, :integer, default: 0
  end
end
