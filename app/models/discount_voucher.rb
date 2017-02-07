class DiscountVoucher < ActiveRecord::Base
  attr_accessible :name, :discount_type, :value, :by_ocurrence, :ocurrences
end
