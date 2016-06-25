class Inventory < ActiveRecord::Base
  attr_accessible :supply_availability, :supply_id, :supply_name
  belongs_to :supply 
end
