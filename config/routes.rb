# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /cn/ do
    get "auth/:provider/callback", to: "sessions#create_from_oauth"
    resources :registrations, only: %i[new create]
    resources :sessions, only: %i[new create]
    resources :categories
    resources :bookmarks, except: %i[index] do
      member do
        post :toggle_liking
        get :hover_like_users
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
    root to: "bookmarks#index"
    get "landing", to: "landing#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
