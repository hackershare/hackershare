# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  around_action :switch_locale
  before_action :authenticate_user!

  helper_method :authenticate_user!, :current_user, :user_signed_in?, :default_host

  helper_method :default_host

  protected

    def default_host
      Rails.application.routes.default_url_options[:host]
    end

    def authenticate_user!
      redirect_to new_session_path, error: t("login_required") unless current_user
    end

    def current_user
      @current_user ||= User.where(remember_token: cookies[:remember_token_v2]).first if cookies[:remember_token_v2]
      if request.headers["HTTP_EXTENSION_TOKEN"].present?
        @current_user ||= User.where(extension_token: request.headers["HTTP_EXTENSION_TOKEN"]).first
      end
      @current_user
    end

    def set_current_user(user, remember_me = true)
      cookies[:remember_token_v2] = if remember_me
        {
          value: user.remember_token,
          expires: 1.year.from_now.utc
        }
      else
        {
          value: user.remember_token
        }
      end
      @current_user = user
      @current_user
    end

    def user_signed_in?
      !!current_user
    end

  private

    def switch_locale(&action)
      if request.path == "/" && best_locale.to_sym != I18n.default_locale && !params[:set_locale]
        redirect_to root_path(locale: best_locale)
      else
        locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
        cookies[:locale] = locale if params[:set_locale]
        I18n.with_locale(locale, &action)
      end
    end

    def default_url_options
      locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
      {
        locale: locale,
      }
    end

    def best_locale
      @best_locale ||= begin
        cookie_locale = I18n.locale_available?(cookies[:locale]) ? cookies[:locale] : nil
        lang = request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
        client_locale = lang == "zh" ? :cn : :en
        cookie_locale || client_locale || I18n.default_locale
      end
    end
end
