class AddPreviousStatusToBills < ActiveRecord::Migration
  def change
    add_column :bills, :previous_status, :string
  end
end
