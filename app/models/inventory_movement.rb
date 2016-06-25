class InventoryMovement < ActiveRecord::Base
  attr_accessible :description, :movement_type, :quantity, :supply_id, :adjustment, :user_id
  paginates_per 10
  belongs_to :supply
  belongs_to :user

	
end
