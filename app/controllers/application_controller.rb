# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!

  helper_method :authenticate_user!, :current_user, :user_signed_in?, :default_host

  helper_method :default_host

  protected

    def default_host
      Rails.application.routes.default_url_options[:host]
    end

    def authenticate_user!
      redirect_to new_session_path, error: "Login Required", status: 401 unless current_user
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
end
