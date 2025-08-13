# app/controllers/seeds_controller.rb
class SeedsController < ApplicationController
  layout false

  def run
    expected_token = "maddock2025secure"
    provided_token = params[:token].to_s

    unless ActiveSupport::SecurityUtils.secure_compare(provided_token, expected_token)
      render plain: "Unauthorized", status: :unauthorized
      return
    end

    unless Rails.env.production?
      render plain: "Not in production", status: :forbidden
      return
    end

    Rails.application.load_seed
    render plain: "Seeds complete."
  rescue => e
    render plain: "Error: #{e.class} - #{e.message}", status: :internal_server_error
  end
end
