# frozen_string_literal: true

class SimilarByTag
  prepend SimpleCommand
  include ActiveModel::Validations

  attr_reader :bookmark, :limit

  def initialize(bookmark, limit = 10)
    @bookmark = bookmark
    @limit    = limit
  end

  def call
    # TODO 如果没有标签，使用文本相似度
    return [] if bookmark.cached_tag_with_aliases_ids.blank?
    pg_ids = Util.to_pg_array(bookmark.cached_tag_with_aliases_ids)
    Bookmark
      .original
      .where("cached_tag_with_aliases_ids && ?", pg_ids)
      .where.not(id: bookmark.id)
      .order("cached_tag_with_aliases_ids <=> '#{pg_ids}'")
      .limit(limit)
  end
end
