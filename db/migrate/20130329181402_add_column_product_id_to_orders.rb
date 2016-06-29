class AddColumnProductIdToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :product_id, :string
	  add_index :orders, :product_id
  end
end
