Rails.application.routes.draw do
  devise_for :users, module: "users",:path_prefix =>'devise' #rutaspara el modulo de user devise
  resources :users #rutas personalizadas para crear usuarios

  get '/users/:id/:estado/state', to: 'users#state', as: 'change_state' #update
  #put '/users/:id/:estado/state', to: 'users#state', as: 'change_state' #update

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :codes
  resources :products
  resources :brands
  resources :home

  get '/home/show_ofertas', to: 'home#show_ofertas', as: 'show_ofertas'

  resources :requests
  resources :roles
  resources :situations
  resources :states
  resources :types

  root 'home#index'

end
