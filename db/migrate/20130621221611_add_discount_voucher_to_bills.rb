class AddDiscountVoucherToBills < ActiveRecord::Migration
  def change
  	add_column :bills, :discount_voucher_id, :integer
  end
end
