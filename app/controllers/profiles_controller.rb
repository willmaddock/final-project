class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)
    handle_response(@profile.save, :new, "Profile was successfully created.")
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    handle_response(@profile.update(profile_params), :edit, "Profile was successfully updated.")
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:user_id, :bio, :location, :avatar)
  end

  # Handle responses for create and update actions
  def handle_response(success, render_action, notice)
    respond_to do |format|
      if success
        format.html { redirect_to @profile, notice: notice }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render render_action, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
end