class AddOcurrencesToDiscountVouchers < ActiveRecord::Migration
  def change
    add_column :discount_vouchers, :ocurrences, :integer, default: nil
    add_column :discount_vouchers, :by_ocurrence, :boolean, default: false
  end
end
