Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create_from_oauth"
  resources :registrations, only: %i[new create]
  resources :sessions, only: %i[new create]
  resources :bookmarks do
    member do
      post :toggle_liking
    end
    resources :comments
  end
  resources :extensions, only: %i[create]
  resources :users do
    member do
      get :hover
      get :setting
      put :update_setting
      post :toggle_following
    end
  end
  delete "sign_out" => "sessions#destroy", as: :destroy_session
  root to: "bookmarks#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
