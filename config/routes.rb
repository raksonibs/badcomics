Rails.application.routes.draw do

  root 'users#normal'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do       
     resources :comics, :only => [:index]
    end

    resource :spark, controller: 'spark' do 
      get 'replay'
    end
  end

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

  get '/replay' => 'users#replay'

  get '/about' => 'users#about', as: :about

  get '/first' => 'users#first', as: :first

  get '/next/:current' => 'users#next', as: :next

  get '/prev/:current' => 'users#prev', as: :prev

  get '/zohoverify/verifyforzoho' => 'users#zoho'

  get '/unpublish/:image_id' => 'users#unpublish', as: :unpublish
  get '/publish/:image_id' => 'users#publish', as: :publish
  get '/unshowtitle/:image_id' => 'users#unshowtitle', as: :unshowtitle
  get '/showtitle/:image_id' => 'users#showtitle', as: :showtitle

  get '/save_order' => 'users#save_order', as: :save_order

  get '/store' => 'store#index', as: :store

  get '/test_page' => 'store#test'

  # get '/checkout' => 'store#checkout'
  scope :format => true, :constraints => { :format => 'json' } do
    get '/store/:cart_id/:product_id' => 'store#add_to_cart', as: :add_to_cart
    get '/payment' => 'store#create_customer', as: :payment
  end
  get '/store/:cart_id/remove_from_cart/:product_id' => 'store#remove_from_cart', as: :remove_from_cart

  resources :registrations
  resources :products
  resources :carts

  match '/contacts', to: 'contacts#new', via: 'get'
  resources "contacts", only: [:new, :create]

  resources :images

  match '/404', to: 'users#error_404', via: :all
  match '/422', to: 'users#error_422', via: :all
  match '/500', to: 'users#error_us', via: :all

  get '/new_sub', to: 'subscribers#new'
  
  get '*path' => redirect('/404')
end
