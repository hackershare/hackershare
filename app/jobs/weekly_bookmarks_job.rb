# frozen_string_literal: true

class WeeklyBookmarksJob < ApplicationJob
  queue_as :default

  def perform
    weekly_selection = WeeklySelection.where(is_published: false).last
    return unless weekly_selection
    User.find_each do |user|
      WeeklyMailer.with(user: user, weekly_selection: weekly_selection).notify.deliver_later
    end
  end
end
