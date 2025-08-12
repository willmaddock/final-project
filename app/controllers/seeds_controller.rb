class SeedsController < ApplicationController
  layout false

  def run
    if ENV["SEED_TRIGGER_TOKEN"].present? && params[:token] == ENV["SEED_TRIGGER_TOKEN"]
      load Rails.root.join("db/seeds.rb")
      render plain: "✅ Seeds ran successfully."
    else
      render plain: "❌ Unauthorized", status: :unauthorized
    end
  end
end
