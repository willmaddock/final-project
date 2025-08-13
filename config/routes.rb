# config/routes.rb
Rails.application.routes.draw do
  # ✅ One-time seed trigger route (secured via token in SeedsController)
  get "/run_seeds", to: "seeds#run"

  # 🚀 One-time migration trigger route (secured via token; REMOVE after running in production)
  if Rails.env.production?
    get "/migrate", to: proc { |env|
      req = Rack::Request.new(env)
      provided = req.params["token"].to_s
      expected = "maddock2025secure"

      unless ActiveSupport::SecurityUtils.secure_compare(provided, expected)
        [401, { "Content-Type" => "text/plain" }, ["Unauthorized"]]
      else
        begin
          ActiveRecord::Base.connection.migration_context.migrate
          [200, { "Content-Type" => "text/plain" }, ["Migrations complete!"]]
        rescue => e
          [500, { "Content-Type" => "text/plain" }, ["Migration failed: #{e.class} - #{e.message}"]]
        end
      end
    }
  end

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
  post "users/admin_create", to: "users#create", as: "admin_create_user"

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
