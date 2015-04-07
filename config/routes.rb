Rails.application.routes.draw do
  # resources :users

  root 'users#normal'

  get '/home/:user_id' => 'users#home', as: :home

  post '/upload/:user_id' => 'users#upload', :as => :upload
  patch '/upload/:user_id' => 'users#upload', :as => :upload_patch

  resources :sessions
  resources :users

  get 'login' => 'sessions#new', :as => :login
  post 'logout' => 'sessions#destroy', :as => :logout
  
end