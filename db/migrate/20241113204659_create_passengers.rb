class CreatePassengers < ActiveRecord::Migration[6.1]
  def change
    create_table :passengers do |t|
      t.references :journey, null: false, foreign_key: true
      t.string :name
      t.decimal :cost, precision: 10, scale: 2

      t.timestamps
    end
  end
end
