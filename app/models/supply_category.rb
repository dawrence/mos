class SupplyCategory < ActiveRecord::Base
  attr_accessible :image, :name, :order
  has_many :supplies, dependent: :destroy
  
end
