class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]
  before_action :authorize_profile!, only: %i[edit update destroy]
  before_action :redirect_if_profile_exists, only: %i[new create]

  # GET /profiles
  def index
    per_page = (params[:per_page].presence || 12).to_i
    @profiles = Profile.page(params[:page]).per(per_page)

    @profiles = @profiles.joins(:user).where('users.username = ?', params[:username]) if params[:username].present?
    @profiles = @profiles.where(location: params[:location]) if params[:location].present?
    @profiles = @profiles.joins(:user).where('users.email = ?', params[:email]) if params[:email].present?

    render 'index'
  rescue StandardError => e
    flash.now[:alert] = "Failed to load profiles: #{e.message}"
    @profiles = []
    render 'index'
  end

  # GET /profiles/1
  def show
    @comment = Comment.new
    @comments = @profile.comments.includes(:user).order(created_at: :desc)
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @profile.user_id = current_user.id
    @users = User.where.not(id: Profile.select(:user_id))
  end

  # GET /profiles/1/edit
  def edit
    @users = User.where(id: @profile.user_id)
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id

    if @profile.save
      redirect_to @profile, notice: "Profile was successfully created."
    else
      flash.now[:alert] = @profile.errors.full_messages.to_sentence
      @users = User.where.not(id: Profile.select(:user_id))
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
  def update
    @users = User.where(id: @profile.user_id)
    handle_response(@profile.update(profile_params), :edit, "Profile was successfully updated.")
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def authorize_profile!
    unless current_user.admin? || current_user.logistics_manager? || @profile.user == current_user
      redirect_to root_path, alert: "You do not have permission to perform this action."
    end
  end

  def redirect_if_profile_exists
    if Profile.exists?(user_id: current_user.id)
      redirect_to profile_path(current_user.profile), alert: "You already have a profile."
    end
  end

  def profile_params
    params.require(:profile).permit(:bio, :location, :avatar)
  end

  def handle_response(success, render_action, notice)
    respond_to do |format|
      if success
        format.html { redirect_to @profile, notice: notice }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render render_action, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
end