class AddAdjustmentCheck < ActiveRecord::Migration
  def change
  	add_column :inventory_movements, :adjustment, :boolean, default: false
  end
end
