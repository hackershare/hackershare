class CreateBookmarkStats < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmark_stats do |t|
      t.belongs_to :bookmark
      t.date :date_id
      t.string :date_type, default: "daily"
      t.integer :likes_count, default: 0
      t.integer :dups_count, default: 0
      t.integer :score, default: 0
      t.index %i[date_id date_type bookmark_id], unique: true
      t.index %i[date_id date_type score], order: {date_id: :desc, date_type: :desc, score: :desc}
    end
    add_column :bookmarks, :score, :integer, default: 0
    add_index :bookmarks, :score, order: {score: :desc}
    add_column :bookmarks, :smart_score, :float, default: 0
    add_index :bookmarks, :smart_score, order: {smart_score: :desc}
  end
end
