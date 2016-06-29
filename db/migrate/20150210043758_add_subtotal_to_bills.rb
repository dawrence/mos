class AddSubtotalToBills < ActiveRecord::Migration
  def change
    add_column :bills, :discount_value, :float, default: 0
    add_column :bills, :total, :float, default: 0
  end
end
