class AddColumnTotalDiscountToClosingStages < ActiveRecord::Migration
  def change
    add_column :closing_stages, :total_discount, :float, default: 0
  end
end
