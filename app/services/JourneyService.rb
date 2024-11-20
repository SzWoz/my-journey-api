class JourneyService
  COST_PER_KM = 0.5 # Example cost per km

  def initialize(journey, locations_data)
    @journey = journey
    @locations_data = locations_data
  end

  def call
    process_locations
  end

  private

  def process_locations
    passengers_distance = Hash.new(0)

    @locations_data.each do |location_data|
      location = create_location(location_data)
      accumulate_distances(location, location_data, passengers_distance)
    end

    calculate_and_assign_costs(passengers_distance)
  end

  def create_location(location_data)
    @journey.locations.create!(
      formatted_address: location_data[:data][:formattedAddress],
      lat: location_data[:data][:lat],
      lng: location_data[:data][:lng],
      distance: location_data[:distance]
    )
  end

  def accumulate_distances(location, location_data, passengers_distance)
    location_data[:assignedUsers]&.each do |user_data|
      passenger = @journey.passengers.find_or_create_by!(name: user_data[:name])
      passengers_distance[passenger.name] += location.distance.to_f if location.distance
    end
  end

  def calculate_and_assign_costs(passengers_distance)
    passengers_distance.each do |name, total_distance|
      passenger = @journey.passengers.find_by(name:)
      passenger.update!(cost: total_distance * COST_PER_KM)
    end
  end
end
