# frozen_string_literal: true

class InitComment
  prepend SimpleCommand
  include ActiveModel::Validations

  attr_reader :bookmark

  def initialize(bookmark)
    @bookmark = bookmark
  end

  def call
    return if bookmark.ref_id.present?
    return if bookmark.comments_count >= 1
    return if bookmark.description.blank?
    return if bookmark.description.to_s.size > 280
    return if /[<>]/.match?(bookmark.description.to_s)
    pinned_comment_text = bookmark.description
    pinned_comment = bookmark.comments.create(user: User.rss_robot, comment: pinned_comment_text)
    bookmark.update(pinned_comment: pinned_comment)
    pinned_comment
  end
end
