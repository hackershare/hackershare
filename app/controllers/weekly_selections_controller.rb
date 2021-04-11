# frozen_string_literal: true

class WeeklySelectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @weekly_selections = WeeklySelection.where(lang: [locale_lang, :all_lang]).order(id: :desc).limit(100)
  end

  def show
    @weekly_selection = WeeklySelection.includes(:bookmarks).find(params[:id])
    @last_weekly_selection = WeeklySelection.where(lang: [locale_lang, :all_lang]).order(issue_no: :desc).find_by("issue_no < ?", @weekly_selection.issue_no)
    @next_weekly_selection = WeeklySelection.where(lang: [locale_lang, :all_lang]).order(:issue_no).find_by("issue_no > ?", @weekly_selection.issue_no)
  end

  def new
    @weekly_selecting_bookmarks = Bookmark.where(lang: locale_lang).weekly_selecting.excellented_order
    @weekly_selection = WeeklySelection.where(lang: locale_lang).new(
      issue_no: (WeeklySelection.where(lang: [locale_lang, :all_lang]).maximum(:issue_no)&.next || 1),
      title: @weekly_selecting_bookmarks.first&.title,
    )
  end

  def create
    authorize WeeklySelection
    @weekly_selection = WeeklySelection.where(lang: locale_lang).create!(weekly_selection_params)
    @weekly_selection.bookmarks = Bookmark.where(lang: locale_lang).weekly_selecting.excellented_order.limit(WeeklySelection::BOOKMARKS_COUNT)
    @weekly_selection.save!
    flash[:success] = t("operation_succeeded")
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
        :issue_no,
        :title,
        :description,
      )
    end
end
