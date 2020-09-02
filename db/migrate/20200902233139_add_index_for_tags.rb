class AddIndexForTags < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, :bookmarks_count, order: { bookmarks_count: :desc }
  end
end
