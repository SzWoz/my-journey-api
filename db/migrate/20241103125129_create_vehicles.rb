class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.integer :year
      t.string :manufacturer
      t.string :model
      t.string :version
      t.decimal :fuel_efficiency, precision: 2, scale: 2

      t.timestamps
    end
  end
end
