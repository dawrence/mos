class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :supply_id
      t.integer :menu_product_id
      t.float :quantity

      t.timestamps
    end
    add_index :ingredients, :supply_id
    add_index :ingredients, :menu_product_id
  end
end
