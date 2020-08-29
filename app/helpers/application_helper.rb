# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

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

  if Rails.env.development?
    def t(*args, **options, &block)
      super(*args, **options.merge(raise: true), &block)
    end
  end
end
