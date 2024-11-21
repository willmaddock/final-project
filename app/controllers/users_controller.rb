class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy create new]

  # GET /users or /users.json
  def index
    per_page = (params[:per_page].presence || 10).to_i
    @users = User.all

    @users = @users.where("username LIKE ?", "%#{params[:username]}%") if params[:username].present?
    @users = @users.where("full_name LIKE ?", "%#{params[:full_name]}%") if params[:full_name].present?
    @users = @users.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    @users = @users.where(role: params[:role]) if params[:role].present? && params[:role] != ''

    if params[:status].present?
      case params[:status]
      when 'active'
        @users = @users.where(status: true)
      when 'inactive'
        @users = @users.where(status: false)
      end
    end

    @users = @users.page(params[:page]).per(per_page)
  rescue StandardError => e
    flash.now[:alert] = "Failed to load users: #{e.message}"
    @users = []
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
    @user.password = params[:user][:password] if params[:user][:password].present?

    respond_to do |format|
      if @user.update(user_params.except(:password))
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
    begin
      ActiveRecord::Base.transaction do
        @user.profile&.destroy # Destroy the associated profile if it exists
        @user.access_logs.destroy_all # Destroy all associated access logs
        @user.destroy! # Attempt to delete the user
      end

      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully deleted." }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey
      respond_to do |format|
        format.html do
          redirect_to users_path,
                      alert: "Cannot delete this user because they have related records in the system, such as access logs or other dependencies. Please remove these records first or contact support for assistance."
        end
        format.json { render json: { error: "User has associated records and cannot be deleted." }, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordNotDestroyed => e
      respond_to do |format|
        format.html { redirect_to users_path, alert: "An error occurred: #{e.message}" }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
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