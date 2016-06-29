class AddUpdatedMarkOnBills < ActiveRecord::Migration
  def up
  	add_column :bills, :updated_mk, :boolean, default: false
  end

  def down
  	remove_column :bills, :updated_mk 
  end
end
