Rails.application.routes.draw do


  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      :omniauth_callbacks => "users/omniauth_callbacks"
    },
    path: "auth",
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'secret',
      confirmation: 'verification',
      unlock: 'unblock',
      registration: 'register',
      sign_up: 'signup'
    }

  scope "(:locale)", locale: /it|en/ do
    resources :boats do
      post 'publish', on: :member
      resources :pictures, only: [:index, :new, :create, :destroy]
      # Host's bookings
      resources :bookings, except: [:edit, :update, :destroy] do
        get :accept, on: :member
        get :reject, on: :member
        get :cancel, on: :member
        post :reply, on: :member
      end
      resources :boat_features_sets, as: :features_sets # to avoid boat_boat_features_sets_path
      resources :days, only: [:index, :create, :destroy]
    end

    # Guest's bookings
    get 'my_bookings' => 'bookings#my_bookings', as: :my_bookings

    resources :boat_features
    resources :boat_categories

    # You can have the root of your site routed with "root"
    root to: 'pages#show', id: 'landing'

    # Landing
    get 'pages/*id' => 'pages#show', as: :page, format: false

    # Dashboard
    get 'dashboard' => 'pages#show', id: 'dashboard', as: :dashboard

    # Welcome
    get 'welcome' => 'pages#show', id: 'welcome', as: :welcome
  end
end
