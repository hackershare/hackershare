# frozen_string_literal: true

class BookmarkPolicy < ApplicationPolicy
  def change_lang?
    user&.admin?
  end

  def set_excellent?
    user&.admin? && !record.weekly_selected?
  end

  def priority_excellent?
    set_excellent? && record.is_excellent?
  end
end
