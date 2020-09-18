# frozen_string_literal: true
return if Rails.env.development?
Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"] || "https://318730ee61334b8d926596efb3f9b0ba@o82609.ingest.sentry.io/5429716"
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
