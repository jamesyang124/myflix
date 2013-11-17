Myflix::Application.routes.draw do
  root to: 'videos#front'
  
  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'videos', action: 'index'
  get '/register', to: 'users#new', as: 'register_user'
  get '/sign_in', to: 'sessions#edit'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  resources 'users', only: [:create, :index]
  resources 'categories', only: [:show]
  resources 'videos', only: [:show] do 
    collection do
      get 'search', to: 'videos#search'
    end
  end

end
