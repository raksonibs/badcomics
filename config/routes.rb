Rails.application.routes.draw do
  resources :users

  root 'users#home'
end