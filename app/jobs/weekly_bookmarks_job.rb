# frozen_string_literal: true

class WeeklyBookmarksJob < ApplicationJob
  queue_as :default

  def perform
    chinese_weekly_selection = WeeklySelection.where(is_published: false, lang: :chinese).first
    english_weekly_selection = WeeklySelection.where(is_published: false, lang: :english).first
    User.find_each do |user|
      weekly_selection = user.english? ? english_weekly_selection : chinese_weekly_selection
      WeeklyMailer.with(user: user, weekly_selection: weekly_selection).notify.deliver_later if weekly_selection
    end
  end
end
