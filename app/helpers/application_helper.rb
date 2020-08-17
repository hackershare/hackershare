module ApplicationHelper
  include Pagy::Frontend

  def auth_provider_url(provider = :github)
    if params["chrome-callback"].present?
      "/auth/#{provider}?chrome-callback=#{params['chrome-callback']}"
    else
      "/auth/#{provider}"
    end
  end
end
