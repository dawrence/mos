class RemoveAvailabilityFromSupplies < ActiveRecord::Migration
  def up
  	remove_column :supplies, :availability
  end

  def down
  	add_column :supplies, :availability, :integer, default:0
  end
end
