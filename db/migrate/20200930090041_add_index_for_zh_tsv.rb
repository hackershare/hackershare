class AddIndexForZhTsv < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmarks, :tsv
    execute(<<~SQL)
      alter table bookmarks 
      add column tsv tsvector
      generated always as (
        setweight(to_tsvector('zh', coalesce(title,'')), 'A') ||
        setweight(to_tsvector('zh', coalesce(url,'')), 'A') ||
        setweight(to_tsvector('zh', coalesce(cached_tag_with_aliases_names,'')), 'A') ||
        setweight(to_tsvector('zh', coalesce(description,'')), 'B') ||
        setweight(to_tsvector('zh', coalesce(content,'')), 'D')
      ) stored
    SQL
    enable_extension :rum
    execute("CREATE INDEX boomkark_rum_tsv_idx ON bookmarks USING rum (tsv rum_tsvector_ops);")
  end
end
