# frozen_string_literal: true

class ApplicationNotification < Noticed::Base
  private

    # Cannot use this this method until I18n.locale is already setted
    def default_url_options
      locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
      {
        locale: locale,
      }
    end

    def email_notifications?
      recipient.enable_email_notification? && recipient.email !~ /fakemail.com/
    end
end
