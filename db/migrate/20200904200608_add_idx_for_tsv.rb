class AddIdxForTsv < ActiveRecord::Migration[6.0]
  def change
    execute(<<~SQL)
      CREATE INDEX fulltext_idx ON bookmarks 
      USING GIN (tsv);
    SQL
  end
end
