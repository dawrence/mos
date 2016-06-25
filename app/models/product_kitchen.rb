class ProductKitchen < ActiveRecord::Base
  attr_accessible :kitchen_id, :product_id

  belongs_to :product
  belongs_to :kitchen
  
end
