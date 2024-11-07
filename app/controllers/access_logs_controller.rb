class AccessLogsController < ApplicationController
  before_action :set_access_log, only: %i[ show edit update destroy ]

  # GET /access_logs or /access_logs.json
  def index
    @access_logs = AccessLog.all
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

    # Only allow a list of trusted parameters through.
    def access_log_params
      params.require(:access_log).permit(:user_id, :access_point_id, :timestamp, :successful)
    end
end
