class ChangeWeeklySeletion < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        WeeklySelection.where(title: nil).delete_all
        WeeklySelection.where.not(published_at: nil).update_all('created_at = published_at')
      end
    end
    remove_column :weekly_selections, :published_at, :datetime
    change_column_null :weekly_selections, :title, false
    change_column_null :weekly_selections, :bookmarks_count, false
    add_column :bookmarks, :excellented_at, :datetime
    add_column :bookmarks, :is_excellent, :boolean, null: false, default: false
    reversible do |dir|
      dir.up do
        Bookmark.where.not(weekly_selection_id: nil).update_all(is_excellent: true)
      end
    end
  end
end
