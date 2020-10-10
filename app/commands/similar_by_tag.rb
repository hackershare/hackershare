# frozen_string_literal: true

class SimilarByTag
  prepend SimpleCommand
  include ActiveModel::Validations

  attr_reader :bookmark, :limit

  def initialize(bookmark, limit = 6)
    @bookmark = bookmark
    @limit    = limit
  end

  def call
    pg_ids = Util.to_pg_array(bookmark.cached_tag_with_aliases_ids)
    return Bookmark
      .original
      .where("cached_tag_with_aliases_ids && ?", pg_ids)
      .where.not(id: bookmark.id)
      .order("cached_tag_with_aliases_ids <=> '#{pg_ids}'")
      .limit(limit) if bookmark.cached_tag_with_aliases_ids.present?

    return Bookmark
      .original
      .where("bookmarks.tsv @@ replace(plainto_tsquery('zh', E'#{Util.escape_quote bookmark.title}')::text, '&', '|')::tsquery")
      .where.not(id: bookmark.id)
      .select("bookmarks.*, bookmarks.tsv <=> replace(plainto_tsquery('zh', E'#{Util.escape_quote bookmark.title}')::text, '&', '|')::tsquery AS relevance")
      .order("relevance ASC")
      .limit(limit) if bookmark.title.present?
    []
  end
end
