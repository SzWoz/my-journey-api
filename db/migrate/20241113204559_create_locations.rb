class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.references :journey, null: false, foreign_key: true
      t.string :formatted_address
      t.float :lat
      t.float :lng
      t.float :distance

      t.timestamps
    end
  end
end
