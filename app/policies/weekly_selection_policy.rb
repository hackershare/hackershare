# frozen_string_literal: true

class WeeklySelectionPolicy < ApplicationPolicy
  def create?
    Bookmark.weekly_selecting.count >= WeeklySelection::BOOKMARKS_COUNT
  end
end
