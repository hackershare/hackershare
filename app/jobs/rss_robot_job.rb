# frozen_string_literal: true

class RssRobotJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :hardly

  def perform
    RssSource.find_each do |rss_source|
      ProcessRssJob.perform_now(rss_source.id)
    end
  end
end
