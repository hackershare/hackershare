class AddIsPublishedToWeeklySelections < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_selections, :is_published, :boolean, null: false, default: false
  end
end
