class FixStored < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmark_stats, :score
    execute(<<~SQL)
      alter table bookmark_stats 
      add column score integer 
      generated always as (dups_count + likes_count) stored
    SQL
    add_index :bookmark_stats, %i[date_id date_type score], order: {date_id: :desc, date_type: :desc, score: :desc}
  end
end
