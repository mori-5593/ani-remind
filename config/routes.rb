Rails.application.routes.draw do
  resources :posts do
    collection do
      get :watched
      get :want_to_watch
      get :search
    end

    # postのURLの中にcommentのURLも含める
    resources :comments, only: [ :create, :destroy ]
  end

  get "login", to: "user_sessions#new", as: :login
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy", as: :logout

  resources :passwords, param: :token
  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    delete :remove_avatar, on: :member # アイコン削除処理用パス
  end
  resources :actions, only: [ :create, :update ]

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
