class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]

  # GET /profiles or /profiles.json
  def index
    per_page = (params[:per_page].presence || 10).to_i
    @profiles = Profile.page(params[:page]).per(per_page)

    # Renders the `index` template located at `app/views/profiles/index.html.erb`
    render 'index'
  rescue StandardError => e
    flash.now[:alert] = "Failed to load profiles: #{e.message}"
    @profiles = []
    render 'index'  # Render the same template even in case of an error
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @users = User.all # Load all users for selection
  end

  # GET /profiles/1/edit
  def edit
    @users = User.all # Load all users for selection
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

  # Authorization method to check user permissions for profile actions
  def authorize_profile!
    case action_name
    when 'new', 'create'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_create_profiles?
    when 'edit', 'update'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_edit_profiles?
    when 'destroy'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_delete_profiles?
    else
      return true
    end
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