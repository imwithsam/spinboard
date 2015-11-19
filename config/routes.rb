Rails.application.routes.draw do
  root 'welcome#index'

  get "/logout"        => "sessions#destroy"
  get "/login"         => "sessions#new"
  get "/signup"        => "users#new"
  get "/recommend/new" => "recommend#new"
  post "/recommend"    => "recommend#create"

  resources :users,    only: [:new, :create]
  resources :links,    only: [:index, :create, :update, :edit]
  resources :sessions, only: [:new, :create, :destroy]
end
