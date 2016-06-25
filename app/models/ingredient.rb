class Ingredient < ActiveRecord::Base
  attr_accessible :product_id, :quantity, :supply_id, :quantifiable
  belongs_to :product
  belongs_to :supply

  def self.supplied(su_id)
  	find_by_supply_id(su_id)
  end

end
