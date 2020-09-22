# frozen_string_literal: true

class Admin::BookmarksController < Admin::ApplicationController
  def index
    @pagy, @bookmarks = pagy_countless(
      Bookmark.order(smart_score: :desc),
      items: 20
    )
  end

  def up
    @bookmark = Bookmark.find(params[:id])
    @bookmark.touch(:created_at)
    redirect_to admin_bookmarks_path
  end
end
