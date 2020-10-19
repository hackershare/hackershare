class InitPinnedComment < ActiveRecord::Migration[6.0]
  def change
    Bookmark.find_each do |bookmark|
      next if bookmark.pinned_comment_id.present?
      if bookmark.comments_count >= 1
        bookmark.update(pinned_comment: bookmark.comments.order("id asc").first)
      else
        InitComment.call(bookmark)
      end
    end
  end
end
