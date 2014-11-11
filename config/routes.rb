Whattodo::Application.routes.draw do
  root 'welcome#index'
  get "/whattodo" => "welcome#home"
  get "/test"=>"welcome#test"
  get "/events"=> "events#populate"
  get "/result/:feeling/:activity/:money"=>"welcome#algorthim"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout
  get "events/:event_id" => "events#show"

  # ttp://api.localhost.com/events
  namespace :api, :path => "", :constraints => {:subdomain => "api"} do
    resources :people
  end

end
