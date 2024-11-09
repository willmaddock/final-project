class AccessPointsController < ApplicationController
  before_action :set_access_point, only: %i[show edit update destroy]
  before_action :authorize_access_point!, only: %i[new create edit update destroy]

  # GET /access_points or /access_points.json
  def index
    per_page = (params[:per_page].presence || 10).to_i
    @query = params[:query]

    # Initialize the access points relation
    access_points_relation = AccessPoint.all

    # Filter by selected parameters if present
    if params[:location].present?
      access_points_relation = access_points_relation.where(location: params[:location])
    end

    if params[:access_level].present?
      access_points_relation = access_points_relation.where(access_level: params[:access_level])
    end

    if params[:status].present?
      status_value = params[:status] == 'true'
      access_points_relation = access_points_relation.where(status: status_value)
    end

    # Paginate the relation instead of an array
    @access_points = access_points_relation.page(params[:page]).per(per_page)

    # Renders the `index` template located at `app/views/access_points/index.html.erb`
    render 'index'
  rescue StandardError => e
    flash.now[:alert] = "Failed to load access points: #{e.message}"
    @access_points = AccessPoint.none.page(params[:page]).per(per_page)  # Ensure it's an ActiveRecord relation
    render 'index'  # Render the same template even in case of an error
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
    respond_to do |format|
      if @access_point.destroy
        format.html { redirect_to access_points_path, status: :see_other, notice: "Access point was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to access_point_path(@access_point), alert: "Access point could not be deleted due to dependent records." }
        format.json { render json: { error: "Access point could not be deleted due to dependent records." }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::InvalidForeignKey => e
    Rails.logger.error("Failed to delete access point: #{e.message}")
    flash[:alert] = "Access point could not be deleted due to dependent records."
    redirect_to access_points_path
  end

  private

  # Authorization method to check user permissions for access points
  def authorize_access_point!
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

  # Use callbacks to share common setup or constraints between actions.
  def set_access_point
    @access_point = AccessPoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def access_point_params
    params.require(:access_point).permit(:location, :access_level, :description, :status)
  end
end