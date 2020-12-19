# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class ValidateError < StandardError; end

  include Pagy::Backend
  include Pundit
  around_action :switch_locale
  before_action :authenticate_user!
  before_action :mark_notification

  helper_method :authenticate_user!, :current_user, :user_signed_in?, :default_host, :best_locale

  rescue_from "Pagy::OverflowError" do |e|
    switch_locale do
      flash[:error] = t("page_overflow")
      redirect_back fallback_location: root_path
    end
  end

  rescue_from "Pundit::NotAuthorizedError" do |e|
    respond_to do |format|
      format.html do
        flash[:error] = e.message
        redirect_back fallback_location: root_path
      end
      format.all do
        head :forbidden
      end
    end
  end

  def current_user
    @current_user ||= User.where(remember_token: cookies[:remember_token_v2]).first if cookies[:remember_token_v2]
    if request.headers["HTTP_EXTENSION_TOKEN"].present?
      @current_user ||= User.where(extension_token: request.headers["HTTP_EXTENSION_TOKEN"]).first
    end
    @current_user
  end

  protected

    def default_host
      Rails.application.routes.default_url_options[:host]
    end

    def authenticate_user!
      redirect_to new_session_path, error: t("login_required") unless current_user
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
      if params[:set_locale]
        cookies[:locale] = params[:locale] || I18n.default_locale
      end
      if request.path == "/" && best_locale != I18n.default_locale
        redirect_to root_path(locale: best_locale)
      elsif dync_locale_routes?
        I18n.with_locale(best_locale, &action)
      else
        locale = params[:locale] if I18n.locale_available?(params[:locale])
        I18n.with_locale(locale, &action)
      end
    end

    # Cannot use this this method until I18n.locale is already setted
    def default_url_options
      locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
      {
        locale: locale,
      }
    end

    def best_locale
      @best_locale ||= begin
        cookie_locale = I18n.locale_available?(cookies[:locale]) ? cookies[:locale] : nil
        lang = request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first
        client_locale = lang == "zh" ? :'zh-CN' : :en
        (cookie_locale || client_locale || I18n.default_locale).to_sym
      end
    end

    def dync_locale_routes?
      controller_name == "sessions" && action_name == "create_from_oauth"
    end

    def mark_notification
      if current_user && params[:n_id].present?
        if notification = current_user.notifications.where(id: params[:n_id]).first
          notification.mark_as_read!
        end
      end
    end

    def render_bookmarks
      @tag = params[:tag]
      @query = Util.escape_quote(params[:query]) if params[:query]
      base = Bookmark.includes(:pinned_comment, :tags, :weekly_selection).where(is_display: true).sorting(params).original.preload(:user, :tags)
      base = base.tag_filter(base, @tag) if @tag.present?
      user_lang = current_user.bookmark_lang if user_signed_in?
      @lang = (["language"] + Bookmark.langs.keys).include?(params[:lang]) ? params[:lang] : user_lang
      @lang ||= "language"
      base = base.where(lang: @lang) if Bookmark.langs.key?(@lang)
      if params[:query].present?
        base = base.where("bookmarks.tsv @@ plainto_tsquery('zh', E'#{@query}')")
        base = base.select("bookmarks.*, bookmarks.tsv <=> plainto_tsquery('zh', E'#{@query}') AS relevance")
        base = base.order("relevance ASC")
      end
      @pagy, @bookmarks = pagy_countless(
        base.with_attached_favicon_local,
        items: 15,
        link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
      )
      @suggest_tags = Tag.order(bookmarks_count: :desc).where(is_rss: false).limit(5).pluck(:name)
      @followed_tags = user_signed_in? ? current_user.follow_tags.order(bookmarks_count: :desc) : []
      @unfollowed_tags = Tag.order(bookmarks_count: :desc).where.not(is_rss: true, id: @followed_tags.pluck(:id)).limit(10)
      respond_to do |format|
        format.js { render partial: "bookmarks/bookmarks_with_pagination", content_type: "text/html", locals: { suggest_tags: @suggest_tags, lang: @lang } }
        format.html { render "bookmarks/index" }
      end
    end
end
