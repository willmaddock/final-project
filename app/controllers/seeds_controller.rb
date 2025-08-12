class SeedsController < ApplicationController
  layout false

  def run
    if ENV["SEED_TRIGGER_TOKEN"].present? && params[:token] == ENV["SEED_TRIGGER_TOKEN"]
      # Run pending migrations
      ActiveRecord::MigrationContext.new(
        File.join(Rails.root, "db/migrate"), ActiveRecord::SchemaMigration
      ).migrate

      # Run seeds
      load Rails.root.join("db/seeds.rb")

      render plain: "✅ Migrations and seeds ran successfully."
    else
      render plain: "❌ Unauthorized", status: :unauthorized
    end
  end
end
