Rails.application.routes.draw do

  root 'users#normal'

  get '/home/:user_id' => 'users#home', as: :home

  post '/upload/:user_id' => 'users#upload', :as => :upload
  patch '/upload/:user_id' => 'users#upload', :as => :upload_patch

  get '/register_twofactor' => 'users#twofactor', :as => :two_factor

  resources :sessions, only: [:create]
  get "sessions/two_factor"
  post "sessions/verify"
  post "sessions/resend"

  resources :users

  resources :subscribers, except: [:destroy, :index, :edit, :update]

  get '/unsubscribe/:subscriber_id' => "subscribers#unsubscribe", as: :unsubscribe
  post '/unsubscribe_confirm/:subscriber_id' => "subscribers#unsubscribe_confirm", as: :unsubscribe_confirm 

  get 'login' => 'sessions#new', :as => :login
  post 'logout' => 'sessions#destroy', :as => :logout

  get '/past' => 'users#past', as: :past

  get '/random/:id' => 'users#random', as: :random

  get '/about' => 'users#about', as: :about

  get '/first' => 'users#first', as: :first

  get '/next/:current' => 'users#next', as: :next

  get '/prev/:current' => 'users#prev', as: :prev

  get '/zohoverify/verifyforzoho' => 'users#zoho'

  match '/contacts', to: 'contacts#new', via: 'get'
  resources "contacts", only: [:new, :create]

  resources :images

  match '/404', to: 'users#error_404', via: :all
  match '/422', to: 'users#error_422', via: :all
  match '/500', to: 'users#error_us', via: :all
  
  get '*path' => redirect('/404')
end
