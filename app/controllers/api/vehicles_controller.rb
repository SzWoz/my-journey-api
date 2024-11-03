module Api
  class VehiclesController < ApplicationController
    before_action :authenticate_user!

    def index
      @vehicles = Vehicle.all
      render json: @vehicles, status: :ok
    end

    def show
      @vehicle = Vehicle.find(params[:id])
      render json: @vehicle, status: :ok
    end

    def create
      @vehicle = Vehicle.new(vehicle_params)
      if @vehicle.save
        render json: @vehicle, status: :created
      else
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def vehicle_params
      params.require(:vehicle).permit(:year, :manufacturer, :model, :version, :fuel_efficiency)
    end
  end
end
