<<<<<<< HEAD
Whattodo::Application.routes.draw do
  root 'welcome#index'
  get "/whattodo" => "welcome#home"
  get "/result/:date/:activity/:money"=>"welcome#matchEvents"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

  # ttp://api.localhost.com/events
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do 
      get '/create_token' => "events#create_token"
      resources :events
      get '/today' => "events#today"
    end
  end

end
=======
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
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
