class AddUserIdToInventoryMovements < ActiveRecord::Migration
  def change
    add_column :inventory_movements, :user_id, :integer
  end
end
