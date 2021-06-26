class AddLangToWeeklySelections < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_selections, :lang, :integer, default: 0, null: false
    reversible do |dir|
      dir.up do
        WeeklySelection.update_all("lang = 2")
      end
    end
  end
end
