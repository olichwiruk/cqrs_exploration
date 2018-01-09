Rails.application.routes.draw do
  resources :users
  resources :products
  resources :basket, only: [:index, :update]
  post '/add_products', to: 'basket#add_products', as: 'add_products'
  post '/checkout', to: 'basket#checkout', as: 'checkout'
  get '/login', to: 'users#login_view', as: 'login'
  post '/login', to: 'users#login', as: 'login_user'
  get '/logout', to: 'users#logout', as: 'logout'
end
