Rails.application.routes.draw do
  # resources :users

  root 'users#home'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
end