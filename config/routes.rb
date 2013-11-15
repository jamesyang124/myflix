Myflix::Application.routes.draw do
  root to: 'videos#front'
  
  get 'ui(/:action)', controller: 'ui'
  get 'home', controller: 'videos', action: 'index'
  get '/register', to: 'users#new', as: 'register_user'
  
  resources 'users', only: [:create]
  resources 'categories', only: [:show]
  resources 'videos', only: [:show] do 
    collection do
      get 'search', to: 'videos#search'
    end
  end

end
