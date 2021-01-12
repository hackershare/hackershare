# frozen_string_literal: true

source "https://rubygems.org/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.2"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-performance"
  gem "rubocop-rails"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "capistrano", "~> 3.14.1"
  gem "capistrano-rvm"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano3-puma"
  gem "capistrano-yarn", require: false
  gem "capistrano-sidekiq", "~> 2.beta", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "bcrypt", "~> 3.1"

gem "pry-rails", "~> 0.3.9"

gem "annotate", "~> 3.1"

gem "link_thumbnailer", "~> 3.4"

gem "validate_url", "~> 1.0"

gem "pagy", "~> 3.8"

gem "image_processing", "~> 1.11"

gem "omniauth", "~> 1.9"

gem "dotenv-rails", "~> 2.7", require: "dotenv/rails-now"

gem "omniauth-github", "~> 1.4"

gem "omniauth-twitter", "~> 1.4"

gem "rack-cors", "~> 1.1"

gem "simple_command", "~> 0.1.0"

gem "sitemap_generator", "~> 6.1"

gem "noticed", "~> 1.2"
gem "actionview", ">= 6.0.3.3"

gem "sendgrid-actionmailer", "~> 3.1"

gem "sentry-raven", "~> 3.0"

gem "lavatar", "~> 0.1.5"

gem "feedjira", "~> 3.1", ">= 3.1.1"

gem "httplog", "~> 1.4"

gem "sidekiq", "~> 6.1", ">= 6.1.2"

gem "sidekiq-scheduler", "~> 3.0", ">= 3.0.1"

gem "rails-i18n", "~> 6.x"

gem "seed-fu", "~> 2.3", ">= 2.3.9"
gem "active_storage_silent_logs", group: :development

gem "activestorage_qiniu", "~> 0.2.2"

gem "render_async", "~> 2.1"

gem "lograge", "~> 0.11.2"

gem "device_detector", "~> 1.0"

gem "ahoy_matey", "~> 3.0"

gem "pundit", "~> 2.1"

gem "sidekiq-worker-killer", "~> 1.0"
