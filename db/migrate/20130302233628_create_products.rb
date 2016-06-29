class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :menu_product_id
      t.boolean :original
      t.float :price

      t.timestamps
    end
    add_index :products, :menu_product_id
  end
end
