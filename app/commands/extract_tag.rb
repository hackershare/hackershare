# frozen_string_literal: true

class ExtractTag
  prepend SimpleCommand
  include ActiveModel::Validations

  attr_reader :bookmark

  def initialize(bookmark)
    @bookmark = bookmark
  end

  def call
    tags = Tag.find_by_sql(<<~SQL)
      SELECT DISTINCT 
             tags.*, 
             bookmarks.tsv <=> plainto_tsquery('zh', name) AS rev_score
        FROM bookmarks, tags 
       WHERE bookmarks.id = #{bookmark.id} 
             AND plainto_tsquery('zh', tags.name) @@ bookmarks.tsv
             AND tags.name not IN (#{Util.stop_words_for_where})
             AND length(tags.name) > 3
             AND tags.bookmarks_count > 10
    ORDER BY rev_score ASC
       LIMIT 10
    SQL
    tags.map(&:preferred_or_self).uniq[0, 3]
  end
end
