class AddAttributesToWeeklySelections < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_selections, :title, :string
    add_column :weekly_selections, :published_at, :datetime
    reversible do |dir|
      dir.up do
        WeeklySelection.where.not(published_at: nil).find_each do |ws|
          ws.update!(published_at: ws.created_at, title: 'TODO', description: 'TODO', description_en: 'TODO')
        end
      end
    end
  end
end
