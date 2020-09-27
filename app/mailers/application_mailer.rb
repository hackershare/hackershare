# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Hackershare <noreply@hackershare.dev>"
  layout "mailer"

  def default_url_options
    locale = I18n.locale == I18n.default_locale ? nil : "cn"
    {
      locale: locale,
    }
  end
end
