# frozen_string_literal: true

class Admin::BookmarksController < Admin::ApplicationController
  def index
    @pagy, @bookmarks = pagy_countless(
      Bookmark.order(id: :desc),
      items: 20
    )
  end
end
