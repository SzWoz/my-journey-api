class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :country
      t.decimal :gasoline_95
      t.decimal :diesel
      t.decimal :lpg

      t.timestamps
    end
  end
end
