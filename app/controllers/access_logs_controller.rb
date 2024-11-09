class AccessLogsController < ApplicationController
  before_action :set_access_log, only: %i[show edit update destroy]
  before_action :authorize_access_log!, only: %i[new create edit update destroy]  # Authorization check for certain actions

  # GET /access_logs or /access_logs.json
  def index
    per_page = (params[:per_page].presence || 10).to_i

    # Build the query dynamically based on selected filter
    @access_logs = AccessLog.joins(:user, :access_point)

    if params[:username].present?
      @access_logs = @access_logs.where(users: { username: params[:username] })
    end

    if params[:address].present?
      @access_logs = @access_logs.where(access_points: { location: params[:address] })
    end

    if params[:success].present?
      success_value = params[:success] == 'true'
      @access_logs = @access_logs.where(successful: success_value)
    end

    # Date filtering based on params[:date]
    if params[:date].present?
      date = Date.parse(params[:date]) rescue nil
      if date
        @access_logs = @access_logs.where(timestamp: date.beginning_of_day..date.end_of_day)
      end
    end

    @access_logs = @access_logs.page(params[:page]).per(per_page)
  rescue StandardError => e
    flash.now[:alert] = "Failed to load access logs: #{e.message}"
    @access_logs = []
  end

  # GET /access_logs/1 or /access_logs/1.json
  def show
  end

  # GET /access_logs/new
  def new
    @access_log = AccessLog.new
  end

  # GET /access_logs/1/edit
  def edit
  end

  # POST /access_logs or /access_logs.json
  def create
    @access_log = AccessLog.new(access_log_params)

    respond_to do |format|
      if @access_log.save
        format.html { redirect_to @access_log, notice: "Access log was successfully created." }
        format.json { render :show, status: :created, location: @access_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @access_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_logs/1 or /access_logs/1.json
  def update
    respond_to do |format|
      if @access_log.update(access_log_params)
        format.html { redirect_to @access_log, notice: "Access log was successfully updated." }
        format.json { render :show, status: :ok, location: @access_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @access_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_logs/1 or /access_logs/1.json
  def destroy
    @access_log.destroy!

    respond_to do |format|
      format.html { redirect_to access_logs_path, status: :see_other, notice: "Access log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_access_log
    @access_log = AccessLog.find(params[:id])
  end

  # Authorization method to check user permissions for access logs
  def authorize_access_log!
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

  # Only allow a list of trusted parameters through.
  def access_log_params
    params.require(:access_log).permit(:user_id, :access_point_id, :timestamp, :successful)
  end
end