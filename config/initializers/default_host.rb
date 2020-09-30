# frozen_string_literal: true

# NOTICE: http://lulalala.logdown.com/posts/5835445-rails-many-default-url-options
if Rails.env.production?
  Rails.application.routes.default_url_options[:host] = "hackershare.dev"
  Rails.application.routes.default_url_options[:protocol] == "https"
else
  Rails.application.routes.default_url_options[:host] = "localhost:3000"
end
