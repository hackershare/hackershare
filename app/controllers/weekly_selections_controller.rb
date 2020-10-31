# frozen_string_literal: true

class WeeklySelectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @weekly_selections = WeeklySelection.published.order(id: :desc).limit(100)
  end

  def show
    @weekly_selection = WeeklySelection.published.includes(:bookmarks).find(params[:id])
    @last_weekly_selection = WeeklySelection.published.order(id: :desc).find_by("id < ?", @weekly_selection.id)
    @next_weekly_selection = WeeklySelection.published.order(:id).find_by("id > ?", @weekly_selection.id)
  end
end
