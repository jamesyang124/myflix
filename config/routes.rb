Myflix::Application.routes.draw do
  get '/home', controller: 'videos', action: 'index'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create', as: nil
  get '/sign_out', to: 'sessions#destroy'
  
  get '/register', to: 'users#new', as: 'register_user'
  resources 'users', only: [:create]

  resources 'categories', only: [:show]
  resources 'videos', only: [:show] do 
    collection do
      post 'search', to: 'videos#search'
    end

    resources 'reviews', only: [:create]
  end

  resources 'queue_items', only: [:index, :create, :destroy], path: 'my_queue'
  post 'update_queue', to: 'queue_items#update_queue'


  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
end
