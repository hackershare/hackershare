# frozen_string_literal: true

class CleanNotificationJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :hardly

  def perform
    Notification.where("created_at < ?", 1.week.ago).destroy_all
  end
end
