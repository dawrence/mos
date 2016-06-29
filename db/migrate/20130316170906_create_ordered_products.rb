class CreateOrderedProducts < ActiveRecord::Migration
  def change
    create_table :ordered_products do |t|
      t.integer :product_id
      t.integer :menu_product_id

      t.timestamps
    end
    add_index :ordered_products, :product_id
    add_index :ordered_products, :menu_product_id
  end
end
