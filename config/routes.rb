Myflix::Application.routes.draw do
  root to: 'videos#front'
  
  
  get '/home', controller: 'videos', action: 'index'
  get '/sign_in', to: 'sessions#edit'
  post '/sign_in', to: 'sessions#create', as: nil
  get '/sign_out', to: 'sessions#destroy'
  
  get '/register', to: 'users#new', as: 'register_user'
  resources 'users', only: [:create]

  resources 'categories', only: [:show]
  resources 'videos', only: [:show] do 
    collection do
      get 'search', to: 'videos#search'
    end
  end

  get 'ui(/:action)', controller: 'ui'
end
