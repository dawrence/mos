class ChangeProductIdFromOrdersType < ActiveRecord::Migration
  def up
  	remove_index :orders, :product_id 
  	remove_column :orders, :product_id
  	add_column :orders, :product_id, :integer
  	add_index :orders, :product_id
  end

  def down
  	remove_index :orders, :product_id 
  	change_column :orders, :product_id, :string
  	add_index :orders, :product_id
  end
end
