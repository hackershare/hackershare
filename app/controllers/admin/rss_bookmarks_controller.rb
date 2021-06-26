# frozen_string_literal: true

class Admin::RssBookmarksController < Admin::ApplicationController
  before_action :set_rss_bookmark, only: %i[display undisplay]

  def index
    @pagy, @rss_bookmarks = pagy_countless(
      Bookmark.rss.order(id: :desc),
      items: 25
    )
  end

  def display
    if @rss_bookmark.update(is_display: true)
      flash[:success] = "Displayed successfully"
    else
      flash[:error] = "Displayed failed: #{@rss_bookmark.short_error_message}"
    end
    redirect_to action: :index
  end

  def undisplay
    if @rss_bookmark.update(is_display: false)
      flash[:success] = "Undisplayed successfully"
    else
      flash[:error] = "Undisplayed failed: #{@rss_bookmark.short_error_message}"
    end
    redirect_to action: :index
  end

  private

  def set_rss_bookmark
    @rss_bookmark = Bookmark.rss.find(params[:id])
  end
end
