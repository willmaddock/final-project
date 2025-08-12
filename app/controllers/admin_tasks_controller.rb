class AdminTasksController < ApplicationController
  def run_setup
    # Hardcoded token for one-time use
    expected_token = "maddock2025secure"
    provided_token = params[:token]

    unless provided_token == expected_token
      render plain: "Unauthorized", status: :unauthorized
      return
    end

    if Rails.env.production?
      ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).migrate
      Rails.application.load_seed
      render plain: "Migration and seed complete."
    else
      render plain: "Not in production."
    end
  end
end
