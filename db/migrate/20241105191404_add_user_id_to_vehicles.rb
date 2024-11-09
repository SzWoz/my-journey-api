class AddUserIdToVehicles < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :user_id, :integer
    add_index :vehicles, :user_id
  end
end
