Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Resources for the application
  resources :access_logs
  resources :access_points
  resources :profiles
  resources :users

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Define the root path route
  root "users#index"  # Setting the home page to the users index action
end