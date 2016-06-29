class AddOrderToProductFamily < ActiveRecord::Migration
  def change
    add_column :product_families, :order, :integer
  end
end
