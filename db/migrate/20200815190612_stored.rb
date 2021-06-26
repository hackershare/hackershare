class Stored < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmarks, :score
    execute(<<~SQL)
      alter table bookmarks 
      add column score integer 
      generated always as (dups_count + likes_count) stored
    SQL
    add_index :bookmarks, :score, order: {score: :desc}
  end
end
