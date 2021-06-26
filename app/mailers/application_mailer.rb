# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Hackershare <noreply@hackershare.dev>"
  layout "mailer"

  def default_url_options
    locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
    {
      locale: locale
    }
  end

  def email_notifications?(user)
    return unless user
    return if Rails.env.development?
    return if user.email == User::RSS_BOT_EMAIL
    user.enable_email_notification? && user.email !~ /fakemail.com/
  end
end
