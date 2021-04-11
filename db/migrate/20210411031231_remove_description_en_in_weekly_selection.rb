class RemoveDescriptionEnInWeeklySelection < ActiveRecord::Migration[6.0]
  def change
    remove_column :weekly_selections, :description_en, :text
  end
end
