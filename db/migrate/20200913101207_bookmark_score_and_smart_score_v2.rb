class BookmarkScoreAndSmartScoreV2 < ActiveRecord::Migration[6.0]
  def change
    # RE generate bookmark_stats.score
    remove_column :bookmark_stats, :score
    execute(<<~SQL)
      alter table bookmark_stats 
      add column score integer 
      generated always as (dups_count * 3 + likes_count * 2 + clicks_count) stored
    SQL
    add_index :bookmark_stats, %i[date_id date_type score], order: {date_id: :desc, date_type: :desc, score: :desc}

    # re generate bookmarks.score
    remove_column :bookmarks, :score
    execute(<<~SQL)
      alter table bookmarks
      add column score integer
      generated always as (dups_count * 3 + likes_count * 2 + clicks_count) stored
    SQL
    add_index :bookmarks, :score, order: {score: :desc}

    # RE generate bookmarks.smart_score
    remove_column :bookmarks, :smart_score
    execute(<<~SQL)
      alter table bookmarks 
      add column smart_score float 
      generated always as (log(likes_count * 2 + dups_count * 3 + clicks_count + 1.1) + EXTRACT(EPOCH FROM(created_at - '2020-08-10')) / 4500) stored
    SQL
    add_index :bookmarks, :smart_score, order: {smart_score: :desc}
  end
end
