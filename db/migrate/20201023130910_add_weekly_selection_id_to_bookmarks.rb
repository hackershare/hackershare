class AddWeeklySelectionIdToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :weekly_selection_id, :bigint, index: true
  end
end
