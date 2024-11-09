class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy create new]  # Authorization check for new, editing, creating, and deleting

  # GET /users or /users.json
  def index
    per_page = (params[:per_page].presence || 10).to_i  # Convert to integer and use default if not present
    @users = User.all

    # Apply filters based on the selected dropdown values
    @users = @users.where("username LIKE ?", "%#{params[:username]}%") if params[:username].present?
    @users = @users.where("full_name LIKE ?", "%#{params[:full_name]}%") if params[:full_name].present?
    @users = @users.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    @users = @users.where(role: params[:role]) if params[:role].present? && params[:role] != ''
    @users = @users.where(status: params[:status]) if params[:status].present? && params[:status] != ''

    @users = @users.page(params[:page]).per(per_page)
  rescue StandardError => e
    flash.now[:alert] = "Failed to load users: #{e.message}"
    @users = []  # Fallback to an empty array to prevent errors in the view
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

    # Set default password if not provided
    @user.password = "password" if @user.password.blank?

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
    # Update the password only if a new password is provided
    @user.password = params[:user][:password] if params[:user][:password].present?

    respond_to do |format|
      if @user.update(user_params.except(:password)) # Exclude password unless explicitly provided
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

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    case action_name
    when 'new', 'create'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_create_items?
    when 'edit', 'update'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_edit_items?
    when 'destroy'
      redirect_to root_path, alert: "You do not have permission to perform this action." unless current_user.can_delete_items?
    else
      return true
    end
  end

  def user_params
    params.require(:user).permit(:username, :full_name, :email, :role, :access_level, :last_login, :status, :password)
  end
end