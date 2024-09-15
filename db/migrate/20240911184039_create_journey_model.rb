class CreateJourneyModel < ActiveRecord::Migration[6.1]
  def change
    create_table :journey do |t|
      t.string :name
      t.timestamps
    end
  end
end
