class DownNoTagBookmark < ActiveRecord::Migration[6.0]
  def change
    Bookmark.find_each do |b|
      b.update(created_at: 1.month.ago) if b.tags_count.zero?
    end
  end
end
