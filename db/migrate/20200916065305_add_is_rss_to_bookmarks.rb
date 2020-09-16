class AddIsRssToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :is_rss, :boolean, null: false, default: false
  end
end
