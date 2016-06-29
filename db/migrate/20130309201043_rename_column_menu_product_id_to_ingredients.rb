class RenameColumnMenuProductIdToIngredients < ActiveRecord::Migration
  def up
  	remove_column :ingredients, :menu_product_id
  	add_column :ingredients, :product_id, :integer
  	add_index :ingredients, :product_id
  end

  def down
  end
end
