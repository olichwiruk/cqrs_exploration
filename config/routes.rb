Rails.application.routes.draw do
  resources :users
  post '/users/new', to: 'users#create', as: 'create_user'
end
