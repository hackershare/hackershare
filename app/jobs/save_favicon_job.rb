# frozen_string_literal: true

class SaveFaviconJob < ApplicationJob
  queue_as :critical

  def perform(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    bookmark.save_favicon
  end
end
