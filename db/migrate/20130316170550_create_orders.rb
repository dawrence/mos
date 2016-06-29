class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :bill_id
      t.integer :ordered_product_id
      t.boolean :ship

      t.timestamps
    end
    add_index :orders, :bill_id
    add_index :orders, :ordered_product_id
  end
end
