class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy create new]  # Authorization check for new, editing, creating, and deleting

  # GET /users or /users.json
  def index
    begin
      per_page = (params[:per_page] || 10).to_i # Ensure integer conversion
      @users = User.page(params[:page]).per(per_page)
    rescue StandardError => e
      flash.now[:alert] = "Failed to load users: #{e.message}"
      @users = []  # Fallback to an empty array to prevent errors in the view
    end
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    # Handle password directly using Devise
    if params[:user][:password].present?
      @user.password = params[:user][:password]
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = "User was successfully created."
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # Update only if the password is provided; otherwise, retain the existing password
    if params[:user][:password].present?
      @user.password = params[:user][:password] # Use Devise's built-in methods
    end

    respond_to do |format|
      if @user.update(user_params.except(:password_hash)) # Remove password_hash if present
        flash[:notice] = "User was successfully updated."
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Ensure that only admin or logistics manager can delete user details
  def authorize_user!
    case action_name
    when 'new', 'create'
      unless current_user.can_create_items?
        redirect_to root_path, alert: "You do not have permission to perform this action."
      end
    when 'edit', 'update'
      unless current_user.can_edit_items?
        redirect_to root_path, alert: "You do not have permission to perform this action."
      end
    when 'destroy'
      unless current_user.can_delete_items?
        redirect_to root_path, alert: "You do not have permission to perform this action."
      end
    else
      # Default case for show and index actions where all roles have access
      return true
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :full_name, :email, :role, :access_level, :last_login, :status)
  end
end