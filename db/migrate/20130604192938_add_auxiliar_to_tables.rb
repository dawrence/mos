class AddAuxiliarToTables < ActiveRecord::Migration
  def change
    add_column :tables, :auxiliar, :boolean, default: false
  end
end
