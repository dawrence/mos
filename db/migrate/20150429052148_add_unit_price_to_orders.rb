class AddUnitPriceToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :unit_price, :float, default: 0
  	add_column :additionals, :unit_price, :float, default: 0
  end
end
