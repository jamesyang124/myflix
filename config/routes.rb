require 'sidekiq/web' unless Rails.env == "production"

Myflix::Application.routes.draw do
  get '/home', controller: 'videos', action: 'index'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create', as: nil
  get '/sign_out', to: 'sessions#destroy'
  
  get '/register', to: 'users#new', as: 'register_user'
  resources 'users', only: [:create, :show]
  get '/register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  get '/people', to: 'relationships#index'
  resources 'relationships', only: [:create, :destroy]

  resources 'categories', only: [:show]
  resources 'videos', only: [:show] do 
    collection do
      post 'search', to: 'videos#search'
    end

    resources 'reviews', only: [:create]
  end

  get 'forgot_password', to: "forgot_passwords#new"
  get 'forgot_password_confirmation', to: "forgot_passwords#confirm"
  resources 'forgot_passwords', only: [:create]

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: "pages#expired_token"

  resources 'invitations', only: [:new, :create]

  resources 'queue_items', only: [:index, :create, :destroy], path: 'my_queue'
  post 'update_queue', to: 'queue_items#update_queue'

  resources 'plans', only: [:index], path: "billing"
  post 'update_plans', to: 'plans#create'

  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  mount Sidekiq::Web, at: "/sidekiq" unless Rails.env == "production"
  mount StripeEvent::Engine => '/stripe_events'
end
