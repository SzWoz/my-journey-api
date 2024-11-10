class ChangeFuelEfficiencyPrecisionInVehicles < ActiveRecord::Migration[6.1]
  def change
    change_column :vehicles, :fuel_efficiency, :decimal, precision: 10, scale: 2
  end
end
