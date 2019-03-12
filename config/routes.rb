Rails.application.routes.draw do
  #devise_for :users, controllers: { sessions: "users/sessions" }
  devise_for :users, module: "users",:path_prefix =>'devise' #rutaspara el modulo de user devise

  #Layouts renderizados para los controles de inactividad
  match 'active'  => 'sessions#active',  via: :get
  match 'timeout' => 'sessions#timeout', via: :get

  resources :users #rutas personalizadas para crear usuarios

  get '/users/:id/:estado/state', to: 'users#state', as: 'change_state' #update
  #put '/users/:id/:estado/state', to: 'users#state', as: 'change_state' #update

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :codes
  resources :products

  get '/products/:brand/:type/filter', to: 'products#filter', as: 'filter_product'
  resources :brands
  resources :home

  get '/home/:id/supermercado', to: 'home#supermercado', as: 'select_supermercado'

  resources :requests

  get '/request/:id/state', to: 'requests#change_state', as: 'change_state_re'

  resources :roles
  resources :situations
  resources :states
  resources :types

  root 'home#index'

end
