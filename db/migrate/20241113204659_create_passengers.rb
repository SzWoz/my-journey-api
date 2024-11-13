class CreatePassengers < ActiveRecord::Migration[6.1]
  def change
    create_table :passengers do |t|
      t.references :location, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
