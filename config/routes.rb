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
  mount Sidekiq::Web => "/sidekiq"

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
  end

  scope "(:locale)", locale: /cn/ do
    get "auth/:provider/callback", to: "sessions#create_from_oauth"
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
      end
    end
    delete "sign_out" => "sessions#destroy", as: :destroy_session
    root "home#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
