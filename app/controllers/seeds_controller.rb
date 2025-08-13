class SeedsController < ApplicationController
  # Skip authentication for these actions since they're temporary and token-protected for /run_seeds
  skip_before_action :authenticate_user!

  def migrate
    require 'rake'
    Rake::Task.clear
    Rails.application.load_tasks
    Rake::Task['db:migrate'].invoke
    render plain: '✅ Migrations completed successfully.'
  end

  def run
    if params[:token] == ENV['SEED_TRIGGER_TOKEN']
      # Load and run seeds
      Rails.application.load_seed
      render 'run'  # Renders app/views/seeds/run.html.erb with success message
    else
      render plain: 'Invalid token', status: :unauthorized
    end
  end
end