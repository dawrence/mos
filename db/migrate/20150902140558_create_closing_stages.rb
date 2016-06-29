class CreateClosingStages < ActiveRecord::Migration
  def change
    create_table :closing_stages do |t|
      t.float :system_sales
      t.float :system_expenses
      t.float :initial_cash
      t.float :physical_total

      t.timestamps
    end
  end
end
