class AddFuelTypeToVehicles < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :fuel_type, :string
  end
end
