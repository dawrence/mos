class FixColumnNameInInventoryMovements < ActiveRecord::Migration
  def up
  	rename_column :inventory_movements, :suply_id, :supply_id
  end

  def down
  	rename_column :inventory_movements, :supply_id, :suply_id
  end
end
