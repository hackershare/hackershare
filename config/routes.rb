# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /zh-CN/ do
    get "auth/:provider/callback", to: "sessions#create_from_oauth"
    resources :registrations, only: %i[new create]
    resources :sessions, only: %i[new create]
    resources :categories
    resources :bookmarks, except: %i[index] do
      member do
        post :toggle_liking
      end
      resources :comments
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
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
