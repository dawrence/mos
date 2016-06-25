class DiscountVoucher < ActiveRecord::Base
  attr_accessible :name, :discount_type, :value
end