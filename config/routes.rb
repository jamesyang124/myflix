Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
 
  root to: 'videos#index'
  get 'home', controller: 'videos', action: 'index'

  resources 'videos', only: [:show] do 
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources 'categories', only: [:show]

end
