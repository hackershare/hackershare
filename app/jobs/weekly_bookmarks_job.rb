# frozen_string_literal: true

class WeeklyBookmarksJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      WeeklyMailer.with(user: user).notify.deliver_later
    end
  end
end
