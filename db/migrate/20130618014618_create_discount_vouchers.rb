class CreateDiscountVouchers < ActiveRecord::Migration
  def change
    create_table :discount_vouchers do |t|
      t.string :name
      t.string :discount_type
      t.float :value

      t.timestamps
    end
  end
end
