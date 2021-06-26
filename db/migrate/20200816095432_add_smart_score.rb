class AddSmartScore < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmarks, :smart_score
    execute(<<~SQL)
      alter table bookmarks 
      add column smart_score float 
      generated always as (log(likes_count + dups_count + 1.1) + EXTRACT(EPOCH FROM(created_at - '2020-08-10')) / 4500) stored
    SQL
    add_index :bookmarks, :smart_score, order: {smart_score: :desc}
  end
end
