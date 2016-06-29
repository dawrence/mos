class AddCountedToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :counted, :boolean, default: false
  end
end
