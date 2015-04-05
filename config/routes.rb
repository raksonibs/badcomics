Rails.application.routes.draw do
  # resources :users

  root 'users#home'

  # get '/signup' => 'users#new'
  # post '/users' => 'users#create'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  
end