# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "noreply@hackershare.dev"
  layout "mailer"

  def default_url_options
    locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
    {
      locale: locale,
    }
  end
end
