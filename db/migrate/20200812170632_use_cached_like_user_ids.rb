class UseCachedLikeUserIds < ActiveRecord::Migration[6.0]
  def change
    rename_column :bookmarks, :like_user_ids, :cached_like_user_ids
  end
end
