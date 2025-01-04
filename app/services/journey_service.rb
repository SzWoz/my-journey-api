class JourneyService
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
      distance_km = (location.distance.to_f / 1000.0) # Convert meters -> km on the fly
      passengers_distance[passenger.name] += distance_km
    end
  end

  def calculate_and_assign_costs(passengers_distance)
    return if fetch_latest_price.blank?

    fuel_price_per_liter = determine_fuel_price_per_liter
    cost_per_km = calculate_cost_per_km(fuel_price_per_liter)

    assign_costs_to_passengers(passengers_distance, cost_per_km)
  end

  def fetch_latest_price
    Price.last
  end

  def determine_fuel_price_per_liter
    vehicle = @journey.vehicle
    current_price = fetch_latest_price
    choose_fuel_price(vehicle.fuel_type, current_price)
  end

  def calculate_cost_per_km(fuel_price_per_liter)
    vehicle = @journey.vehicle
    liters_per_km = vehicle.fuel_efficiency.to_f / 100.0
    fuel_price_per_liter * liters_per_km
  end

  def assign_costs_to_passengers(passengers_distance, cost_per_km)
    passengers_distance.each do |passenger_name, total_distance|
      total_cost = total_distance * cost_per_km
      passenger = @journey.passengers.find_by(name: passenger_name)
      passenger.update!(cost: total_cost.round(2)) # Round to 2 decimals
    end
  end

  # with a fallback to gasoline_95 for unknown types or if the type is 98.
  def choose_fuel_price(fuel_type, price_record)
    case fuel_type&.downcase
    when '95'
      price_record.gasoline_95
    when 'diesel'
      price_record.diesel
    when 'lpg'
      price_record.lpg
    else
      # fallback if for some reason fuel_type is 98, nil or unknown
      price_record.gasoline_95
    end
  end
end
