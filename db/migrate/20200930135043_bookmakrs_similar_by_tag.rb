class BookmakrsSimilarByTag < ActiveRecord::Migration[6.0]
  def change
    execute("CREATE INDEX idx_similar_by_tag ON bookmarks USING rum (cached_tag_with_aliases_ids rum_anyarray_ops);")
  end
end
