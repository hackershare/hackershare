class FixSlowWeeklySection < ActiveRecord::Migration[6.0]
  def change
    add_index :bookmarks, :weekly_selection_id
  end
end
