class DropOrderedProductsTable < ActiveRecord::Migration
  def up
  	drop_table :ordered_products
  	remove_column :orders, :ordered_product_id
  end

  def down
  	create_table "ordered_p roducts", :force => true do |t|
	    t.integer  "product_id"
	    t.integer  "menu_product_id"
	    t.datetime "created_at",      :null => false
	    t.datetime "updated_at",      :null => false
	  end

	  add_index "ordered_products", ["menu_product_id"], :name => "index_ordered_products_on_menu_product_id"
	  add_index "ordered_products", ["product_id"], :name => "index_ordered_products_on_product_id"

	  add_column :orders, :ordered_product_id, :string
	  add_index :orders, :ordered_product_id
  end
end
