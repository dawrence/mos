class AddTipsTotalToClosingStages < ActiveRecord::Migration
  def change
    add_column :closing_stages, :tips_total, :float
  end
end
