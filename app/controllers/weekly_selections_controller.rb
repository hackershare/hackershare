# frozen_string_literal: true

class WeeklySelectionsController < ApplicationController
  def index
    @weekly_selection = WeeklySelection.includes(:bookmarks).last
    if @weekly_selection
      @last_weekly_selection = WeeklySelection.find_by("id < ?", @weekly_selection.id)
      @next_weekly_selection = WeeklySelection.find_by("id > ?", @weekly_selection.id)
    end
    render :show
  end

  def show
    @weekly_selection = WeeklySelection.includes(:bookmarks).find(params[:id])
    @last_weekly_selection = WeeklySelection.find_by("id < ?", @weekly_selection.id)
    @next_weekly_selection = WeeklySelection.find_by("id > ?", @weekly_selection.id)
  end
end
