# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def disable_with_spinner(text)
    spinner = <<~SPINNER
      <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    SPINNER
    [spinner, text].join.html_safe
  end

  def render_follow_text(user)
    text = user.followed_by?(current_user) ? t("unfollow") : t("follow")
    text.html_safe
  end

  def auth_provider_url(provider = :github)
    if params["chrome-callback"].present?
      "/auth/#{provider}?chrome-callback=#{params['chrome-callback']}"
    else
      "/auth/#{provider}"
    end
  end

  def link_to_active(text, url, current = :bookmarks, options = {})
    if options[:class]
      if params[:controller].to_s == current.to_s
        options[:class] = options[:class] << " bg-gray-900"
      else
        options[:class] = options[:class] << " hover:bg-gray-700"
      end
    end
    link_to text, url, options
  end

  def filter_link_to_active(text, url, current = :smart, options = {})
    if options[:class]
      if (params[:dt].to_s == current.to_s) || (params[:dt].blank? && current.to_s == "smart")
        options[:class] = options[:class] << " bg-gray-200"
      end
    end
    link_to text, url, options
  end

  def hacker_link_to_active(text, url, current = :created, options = {})
    if options[:class]
      if (params[:type].to_s == current.to_s) || (params[:type].blank? && current.to_s == "created")
        options[:class] = options[:class] << " bg-gray-200"
      end
    end
    link_to text, url, options
  end

  def ga_tracking_id
    ENV["GA_TRACKING_ID"] || "UA-175643791-1"
  end

  def tag_url_for(tag, options = {})
    path = Rails.application.routes.recognize_path(request.path)
    if path[:controller] == "bookmarks" && path[:action] == "show"
      link_to tag.name, root_path(tag: tag.name)
    else
      link_to tag.name, url_for(tag: tag.name, only_path: true), data: { remote: true, action: "ajax:success->listing#replace" }
    end
  end

  if Rails.env.development?
    def t(*args, **options, &block)
      super(*args, **options.merge(raise: true), &block)
    end
  end
end
