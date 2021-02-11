class ChangeBookmarkExcellentedPriority < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :excellented_priority, :integer, null: false, default: 0
  end
end
