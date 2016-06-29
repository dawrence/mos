class ChangeAvailabilitySupply < ActiveRecord::Migration
  def up
  	 change_column :supplies, :availability, :integer, default:0
  end

  def down
  	change_column :supplies, :availability, :integer
  end
end
