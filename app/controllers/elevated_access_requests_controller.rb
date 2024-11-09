class ElevatedAccessRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_request_access, only: [:new, :create]
  before_action :ensure_logistics_manager, only: [:approve, :deny]
  before_action :set_elevated_access_request, only: %i[show edit update destroy approve deny]

  # GET /elevated_access_requests or /elevated_access_requests.json
  def index
    @elevated_access_requests = ElevatedAccessRequest.all
  end

  # GET /elevated_access_requests/1 or /elevated_access_requests/1.json
  def show
  end

  # GET /elevated_access_requests/new
  def new
    @elevated_access_request = ElevatedAccessRequest.new
  end

  # GET /elevated_access_requests/1/edit
  def edit
  end

  # POST /elevated_access_requests or /elevated_access_requests.json
  def create
    @elevated_access_request = ElevatedAccessRequest.new(elevated_access_request_params)

    respond_to do |format|
      if @elevated_access_request.save
        format.html { redirect_to @elevated_access_request, notice: "Elevated access request was successfully created." }
        format.json { render :show, status: :created, location: @elevated_access_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @elevated_access_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elevated_access_requests/1 or /elevated_access_requests/1.json
  def update
    respond_to do |format|
      if @elevated_access_request.update(elevated_access_request_params)
        format.html { redirect_to @elevated_access_request, notice: "Elevated access request was successfully updated." }
        format.json { render :show, status: :ok, location: @elevated_access_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @elevated_access_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elevated_access_requests/1 or /elevated_access_requests/1.json
  def destroy
    @elevated_access_request.destroy!

    respond_to do |format|
      format.html { redirect_to elevated_access_requests_path, status: :see_other, notice: "Elevated access request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /elevated_access_requests/:id/approve
  def approve
    if @elevated_access_request.update(status: 'approved')
      redirect_to elevated_access_requests_path, notice: 'Request approved.'
    else
      redirect_to elevated_access_requests_path, alert: 'Failed to approve the request.'
    end
  end

  # POST /elevated_access_requests/:id/deny
  def deny
    if @elevated_access_request.update(status: 'denied')
      redirect_to elevated_access_requests_path, notice: 'Request denied.'
    else
      redirect_to elevated_access_requests_path, alert: 'Failed to deny the request.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_elevated_access_request
    @elevated_access_request = ElevatedAccessRequest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def elevated_access_request_params
    params.require(:elevated_access_request).permit(:user_id, :access_point_id, :reason, :status)
  end

  # Ensure that either Shipping Agents or Logistics Managers can access the request form.
  def ensure_request_access
    unless current_user.role == 'shipping_agent' || current_user.role == 'logistics_manager'
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  # Ensure only Logistics Managers can approve or deny requests.
  def ensure_logistics_manager
    redirect_to root_path, alert: 'Access denied.' unless current_user.role == 'logistics_manager'
  end
end