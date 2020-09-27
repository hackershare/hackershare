class SyncCachedTag < ActiveRecord::Migration[6.0]
  def change
    Bookmark.find_each do |bookmark|
      bookmark.sync_cached_tag_ids
    end
  end
end
