# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end
end

Rails.application.routes.draw do
  # Compatible before
  get "/cn", to: redirect("/")
  get "/cn/*path", to: redirect("/%{path}")

  mount Sidekiq::Web => "/sidekiq"
  get "auth/:provider/callback", to: "sessions#create_from_oauth"

  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :tags
    resources :bookmarks do
      member do
        post :up
        post :down
      end
    end
    resources :dashboard, only: [:index]
    resources :rss_sources, only: %i[index new create edit update destroy] do
      member do
        patch :display
        patch :undisplay
      end
    end
    resources :rss_bookmarks, only: %i[index] do
      member do
        patch :display
        patch :undisplay
      end
    end
    resources :weekly_selections, only: %i[index] do
      member do
        post :publish
        patch :titling
      end
    end
  end

  scope "(:locale)", locale: /en/ do
    resources :weekly_selections, only: %i[index show]
    resources :rss_sources, only: %i[create]
    resources :registrations, only: %i[new create]
    resources :sessions, only: %i[new create]
    resources :notifications do
      collection do
        post :read_all
        post :clear_all
      end
    end
    resources :categories do
      member do
        post :toggle_following
        post :toggle_subscribe
      end
    end
    resources :bookmarks, except: %i[new] do
      member do
        post :toggle_liking
        get :hover_like_users
        get :goto
        patch :weekly_select
      end
      resources :comments
      resources :tags, only: %i[new create]
    end
    resources :extensions, only: %i[create]

    resources :users do
      member do
        get :hover
        post :toggle_following
      end
      collection do
        get :setting
        put :update_setting
        get :top_hackers
      end
    end
    get "about", to: "home#about"
    delete "sign_out", to: "sessions#destroy", as: :destroy_session
    root "home#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
