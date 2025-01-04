module Api
  class JourneysController < ApplicationController
    before_action :set_journey, only: [:update]

    def index
      journeys = Journey.includes(:locations, :passengers)
      render json: journeys, include: { locations: {}, passengers: {} }
    end

    def create
      journey = Journey.new(user_id: current_user.id, vehicle_id: params[:vehicle_id])

      if journey.save
        locations_data = params[:locations]
        JourneyService.new(journey, locations_data).call

        render json: journey, include: { locations: {}, passengers: {} }, status: :created
      else
        render json: { errors: journey.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @journey.vehicle_id = params[:vehicle_id]

      if @journey.save
        # Clear old locations and update with new ones
        @journey.locations.destroy_all
        @journey.passengers.destroy_all
        locations_data = params[:locations]
        JourneyService.new(@journey, locations_data).call

        render json: @journey, include: { locations: {}, passengers: {} }, status: :ok
      else
        render json: { errors: @journey.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_journey
      @journey = Journey.find_by(id: params[:id], user_id: current_user.id)

      return if @journey

        render json: { error: 'Journey not found or unauthorized' }, status: :not_found
    end
  end
end
