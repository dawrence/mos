class AddColumnQuantityToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :quantity, :integer, :default => 0
  end
end
