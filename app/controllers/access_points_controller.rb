class AccessPointsController < ApplicationController
  before_action :set_access_point, only: %i[ show edit update destroy ]

  # GET /access_points or /access_points.json
  def index
    @access_points = AccessPoint.all
  end

  # GET /access_points/1 or /access_points/1.json
  def show
  end

  # GET /access_points/new
  def new
    @access_point = AccessPoint.new
  end

  # GET /access_points/1/edit
  def edit
  end

  # POST /access_points or /access_points.json
  def create
    @access_point = AccessPoint.new(access_point_params)

    respond_to do |format|
      if @access_point.save
        format.html { redirect_to @access_point, notice: "Access point was successfully created." }
        format.json { render :show, status: :created, location: @access_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @access_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_points/1 or /access_points/1.json
  def update
    respond_to do |format|
      if @access_point.update(access_point_params)
        format.html { redirect_to @access_point, notice: "Access point was successfully updated." }
        format.json { render :show, status: :ok, location: @access_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @access_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_points/1 or /access_points/1.json
  def destroy
    @access_point.destroy!

    respond_to do |format|
      format.html { redirect_to access_points_path, status: :see_other, notice: "Access point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_point
      @access_point = AccessPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def access_point_params
      params.require(:access_point).permit(:location, :access_level, :description, :status)
    end
end
