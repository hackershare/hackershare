# frozen_string_literal: true

require "sidekiq"
require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path("../../sidekiq_scheduler.yml", __FILE__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end
