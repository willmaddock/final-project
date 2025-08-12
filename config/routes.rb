Rails.application.routes.draw do
  # ✅ One-time seed trigger route (secured via token)
  get "/run_seeds", to: "seeds#run"

  # Routes for elevated access requests with custom approve and deny actions
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

  # Profiles and nested comments with upvote functionality
  resources :profiles do
    resources :comments, only: [:create, :destroy] do
      member do
        post :upvote
      end
    end
  end

  # Resources for users excluding the create route (handled by Devise and custom route)
  resources :users, except: :create

  # Health check route for the application
  get "up" => "rails/health#show", as: :rails_health_check

  # Define the root path route (default landing page)
  root "users#index"
end
