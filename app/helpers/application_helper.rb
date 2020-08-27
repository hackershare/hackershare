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
end
