class ApplicationNotification < Noticed::Base
  private

    # Cannot use this this method until I18n.locale is already setted
    def default_url_options
      locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
      {
        locale: locale,
      }
    end
end
