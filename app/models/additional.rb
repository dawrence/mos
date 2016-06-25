class Additional < ActiveRecord::Base
  attr_accessible :product_id, :additional_id, :unit_price, :quantity
  
  belongs_to :product
  belongs_to :additional, :class_name => "Product", :foreign_key => "additional_id"

end
