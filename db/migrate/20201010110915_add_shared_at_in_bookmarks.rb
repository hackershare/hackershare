class AddSharedAtInBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :shared_at, :datetime
    reversible do |dir|
      dir.up do
        Bookmark.update_all("shared_at = created_at")
      end
    end
  end
end
