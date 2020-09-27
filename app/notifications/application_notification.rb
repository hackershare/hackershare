# frozen_string_literal: true

class ApplicationNotification < Noticed::Base
  private

    # Cannot use this this method until I18n.locale is already setted
    def default_url_options
      locale = I18n.locale == I18n.default_locale ? nil : "cn"
      {
        locale: locale,
      }
    end

    def email_notifications?
      return if Rails.env.development?
      recipient.enable_email_notification? && recipient.email !~ /fakemail.com/
    end
end
