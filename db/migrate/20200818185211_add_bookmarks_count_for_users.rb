class AddBookmarksCountForUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bookmarks_count, :integer, default: 0
    execute(<<~SQL)
      alter table users 
      add column score integer 
      generated always as (bookmarks_count + (followers_count * 5)) stored
    SQL
    add_index :users, :score, order: {score: :desc}
    add_index :users, :updated_at, order: { updated_at: :desc}
  end
end
