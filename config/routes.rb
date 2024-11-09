Rails.application.routes.draw do
  resources :elevated_access_requests do
    member do
      post :approve
      post :deny
    end
  end

  # Devise routes for user authentication
  devise_for :users

  # Custom route for admin user creation, to avoid conflict with Devise
  post 'users/admin_create', to: 'users#create', as: 'admin_create_user'

  # Resources for the application
  resources :access_logs
  resources :access_points
  resources :profiles
  resources :users, except: :create  # Exclude the default create route for users

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Define the root path route
  root "users#index"  # Setting the home page to the users index action
end