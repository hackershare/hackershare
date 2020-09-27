class AddIdxForTag2 < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmarks, :tsv
    execute(<<~SQL)
      alter table bookmarks 
      add column tsv tsvector
      generated always as (
        setweight(to_tsvector('simple', coalesce(title,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(cached_tag_with_aliases_names,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(description,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(content,'')), 'D')
      ) stored
    SQL
    add_index :bookmarks, :cached_tag_with_aliases_ids, using: :gin
  end
end
