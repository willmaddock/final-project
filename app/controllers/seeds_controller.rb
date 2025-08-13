# app/controllers/seeds_controller.rb
class SeedsController < ApplicationController
  layout false

  # Allow unauthenticated access to the seed endpoint (one-time use)
  skip_before_action :authenticate_user!, only: :run, raise: false
  skip_forgery_protection only: :run

  def run
    token     = params[:token].to_s
    expected  = ENV['SEED_TRIGGER_TOKEN'].to_s

    unless expected.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected)
      render plain: "❌ Unauthorized", status: :unauthorized and return
    end

    # Run pending migrations (supports Rails 6/7)
    ActiveRecord::Base.connection.migration_context.migrate

    # Run seeds
    load Rails.root.join("db/seeds.rb")

    render plain: "✅ Migrations and seeds ran successfully."
  rescue => e
    render plain: "❌ Error: #{e.class} - #{e.message}", status: :internal_server_error
  end
end
