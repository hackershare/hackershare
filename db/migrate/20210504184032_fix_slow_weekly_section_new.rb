class FixSlowWeeklySectionNew < ActiveRecord::Migration[6.0]
  def change
    add_index :bookmarks, [:is_excellent, :weekly_selection_id, :excellented_priority, :excellented_at], order: {excellented_priority: :desc, excellented_at: :asc}, name: "new_weekly_selection_idx"
  end
end
