# config/routes.rb
Rails.application.routes.draw do
  # Startseite
  root "posts#index"

  # Auth
  resource  :session,   only: [:new, :create, :destroy]
  resources :passwords, only: [:new, :create, :edit, :update], param: :token
  resources :registrations, only: [:new, :create]

  # Posts
  resources :posts

  # Healthcheck (für CI)
  get "up" => "rails/health#show", as: :rails_health_check
end
