# frozen_string_literal: true

class WeeklySelectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @weekly_selections = WeeklySelection.order(id: :desc).limit(100)
  end

  def show
    @weekly_selection = WeeklySelection.includes(:bookmarks).find(params[:id])
    @last_weekly_selection = WeeklySelection.order(id: :desc).find_by("id < ?", @weekly_selection.id)
    @next_weekly_selection = WeeklySelection.order(:id).find_by("id > ?", @weekly_selection.id)
  end

  def new
    @weekly_selecting_bookmarks = Bookmark.weekly_selecting.order(excellented_at: :desc)
    @weekly_selection = WeeklySelection.new(
      id: (WeeklySelection.maximum(:id)&.next || 1),
      title: @weekly_selecting_bookmarks.first&.title,
    )
  end

  def create
    authorize WeeklySelection
    @weekly_selection = WeeklySelection.create!(weekly_selection_params)
    @weekly_selection.bookmarks = Bookmark.weekly_selecting.order(excellented_at: :desc).limit(5)
    @weekly_selection.save!
    flash[:success] = "Created successfully."
    redirect_to weekly_selection_path(@weekly_selection)
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = @weekly_selection.short_error_message
    render :new
  end

  def markdown
    if current_user.admin?
      @weekly_selection = WeeklySelection.includes(bookmarks: %i[pinned_comment tags]).find(params[:id])
    else
      head 403
    end
  end

  private

    def weekly_selection_params
      params.require(:weekly_selection).permit(
        :id,
        :title,
        :description,
        :description_en,
      )
    end
end
