module Api
  class VehiclesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_vehicle, only: %i[show update destroy]

    def index
      @vehicles = current_user.vehicles
      render json: @vehicles, status: :ok
    end

    def show
      authorize @vehicle
      render json: @vehicle, status: :ok
    end

    def create
      @vehicle = current_user.vehicles.build(vehicle_params)
      if @vehicle.save
        render json: @vehicle, status: :created
      else
        Rails.logger.error "Vehicle creation failed: #{@vehicle.errors.full_messages.join(', ')}"
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize @vehicle
      if @vehicle.update(vehicle_params)
        render json: @vehicle, status: :ok
      else
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @vehicle
      @vehicle.destroy
      head :no_content
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:year, :manufacturer, :model, :version, :fuel_efficiency, :fuel_type)
    end
  end
end
