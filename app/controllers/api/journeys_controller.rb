module Api
  class JourneysController < ApplicationController
    def index
      journeys = Journey.includes(:locations, :passengers)
      render json: journeys, include: { locations: {}, passengers: {} }
    end

    def create
      journey = Journey.new(user_id: current_user.id, vehicle_id: params[:vehicle_id])

      if journey.save
        locations_data = params[:locations]
        JourneyService.new(journey, locations_data).process_locations

        render json: journey, include: { locations: {}, passengers: {} }, status: :created
      else
        render json: { errors: journey.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
