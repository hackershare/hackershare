class CreateWeeklySelections < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_selections do |t|
      t.integer :bookmarks_count, default: 0
      t.text :description
      t.text :description_en
      t.timestamps
    end
  end
end
