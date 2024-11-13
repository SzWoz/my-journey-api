class JourneyService
  COST_PER_KM = 0.5 # Example cost per km

  def initialize(journey, locations_data)
    @journey = journey
    @locations_data = locations_data
  end

  def process_locations
    passengers_distance = Hash.new(0)

    @locations_data.each do |location_data|
      # Create Location record
      location = @journey.locations.create!(
        formatted_address: location_data[:data][:formattedAddress],
        lat: location_data[:data][:lat],
        lng: location_data[:data][:lng],
        distance: location_data[:distance]
      )

      # Accumulate distances for passengers
      location_data[:assignedUsers]&.each do |user_data|
        passenger = @journey.passengers.find_or_create_by!(name: user_data[:name])
        passengers_distance[passenger.name] += location.distance.to_f if location.distance
      end
    end

    # Calculate and assign costs
    passengers_distance.each do |name, total_distance|
      passenger = @journey.passengers.find_by(name:)
      passenger.update!(cost: total_distance * COST_PER_KM)
      puts "Total cost for #{name}: #{passenger.cost} (#{total_distance} km)"
    end
  end
end
