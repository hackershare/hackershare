# frozen_string_literal: true

class Admin::WeeklySelectionsController < Admin::ApplicationController
  def index
    @weekly_selection = WeeklySelection.unpublished.order(:id).includes(:bookmarks).find_or_create_by!({})
  end

  def publish
    @weekly_selection = WeeklySelection.find(params[:id])
    if @weekly_selection.bookmarks_count != WeeklySelection::BOOKMARKS_COUNT
      raise ValidateError, "The bookmarks count of publishing weekly selection should be equal #{WeeklySelection::BOOKMARKS_COUNT}"
    end
    @weekly_selection.update!(weekly_selection_params)
    WeeklyBookmarksJob.perform_later(@weekly_selection)
    flash[:success] = "Published successfully."
    redirect_back fallback_location: root_path
  rescue ValidateError, ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    redirect_back fallback_location: root_path
  end

  def titling
    @weekly_selection = WeeklySelection.find(params[:id])
    @bookmark = Bookmark.find(params[:bookmark_id])
    @weekly_selection.update!(title: @bookmark.title)
    flash[:success] = "Change weekly selection title successfully."
    redirect_back fallback_location: root_path
  rescue ValidateError, ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    redirect_back fallback_location: root_path
  end

  private

    def weekly_selection_params
      params.require(:weekly_selection).permit(
        :published_at,
        :title,
        :description,
        :description_en,
      )
    end
end
