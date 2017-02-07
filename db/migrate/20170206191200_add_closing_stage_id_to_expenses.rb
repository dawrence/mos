class AddClosingStageIdToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :closing_stage_id, :integer, default: nil
  end
end
