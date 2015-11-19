Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get "/logout" => "sessions#destroy"
  get "/login" => "sessions#new"
  get "/signup" => "users#new"

  resources :users, only: [:new, :create]
  resources :links, only: [:index, :create, :update, :edit]
  resources :sessions, only: [:new, :create, :destroy]
end
