Rails.application.routes.draw do
  # resources :users

  root 'users#normal'

  get '/home' => 'users#home'

  resources :sessions
  resources :users

  get 'login' => 'sessions#new', :as => :login
  post 'logout' => 'sessions#destroy', :as => :logout
  
end