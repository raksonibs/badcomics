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

  get '/past' => 'users#past', as: :past

  get '/random' => 'users#random', as: :random

  get '/about' => 'users#about', as: :about

  get '/first' => 'users#first', as: :first

  get '/next/:current' => 'users#next', as: :next

  get '/prev/:current' => 'users#prev', as: :prev
  
end