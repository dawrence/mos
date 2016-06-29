class DeleteColumnProductIdFromProducts < ActiveRecord::Migration
  def up
  	remove_column :products, :product_id
  end

  def down
  	add_column :products, :product_id, :integer
  end
end
