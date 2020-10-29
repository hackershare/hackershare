# frozen_string_literal: true

if ENV["SMTP_SERVER"].present? && ENV["SMTP_PASSWORD"].present?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: ENV["SMTP_SERVER"],
    user_name: ENV["SMTP_USER"],
    password: ENV["SMTP_PASSWORD"],
    port: ENV["SMTP_PORT"] || 25
  }
end
