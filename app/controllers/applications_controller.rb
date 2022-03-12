require 'securerandom'
require 'active_support'
require 'json'

class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show destroy ]
  skip_before_action :verify_authenticity_token

  # Get all applications (GET /applications)
  def allApplications
    @applications = Application.all.as_json(:except => :id)
    if @applications.blank?
      raise ActiveRecord::RecordNotFound.new('Not Found')
    end
    render json: @applications
  end

  # Get application by A specific app token (GET /applications/:token)
  def applicationByToken
    unless params.blank?
      @applications = Application.where(:app_token => params[:app_token]).as_json(:except => :id)
    end
    if @applications.blank?
      raise ActiveRecord::RecordNotFound.new('Not Found')
    end
    render json: @applications
  end

  # Create new app (POST /applications)
  def create
    unless application_params.blank?
        tokenID = SecureRandom.uuid
        paramsWithToken = application_params.merge(:app_token => tokenID).to_json
        @application = Application.new(JSON.parse(paramsWithToken))
        if @application.save
          @applications = Application.where(:app_token => tokenID).as_json(:except => :id)
          render json: @applications
        else
          raise ActiveRecord::RecordNotFound.new('Not Found')
      end
    end
  end
  

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to application_url(@application), notice: "Application was successfully updated." }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1 or /applications/1.json
  def destroy
    @application.destroy

    respond_to do |format|
      format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:app_name)
    end
end
