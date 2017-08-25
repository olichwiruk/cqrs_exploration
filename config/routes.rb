Rails.application.routes.draw do
  resources :users
  post '/users/new', to: 'users#create', as: 'create_user'
  get '/login', to: 'users#log', as: 'login'
  post '/login', to: 'users#login', as: 'login_user'
  get '/logout', to: 'users#logout', as: 'logout'
end
