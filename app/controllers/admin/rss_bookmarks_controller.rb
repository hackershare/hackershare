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
      redirect_to action: :index
    else
      flash[:error] = "Displayed failed: #{@rss_bookmark.short_error_message}"
      redirect_to action: :index
    end
  end

  def undisplay
    if @rss_bookmark.update(is_display: false)
      flash[:success] = "Undisplayed successfully"
      redirect_to action: :index
    else
      flash[:error] = "Undisplayed failed: #{@rss_bookmark.short_error_message}"
      redirect_to action: :index
    end
  end

  private

    def set_rss_bookmark
      @rss_bookmark = Bookmark.rss.find(params[:id])
    end
end
