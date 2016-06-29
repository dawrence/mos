class AddFixedDataToBills < ActiveRecord::Migration
  def change
  	add_column :bills, :note, :text
  	add_column :bills, :people_quantity, :integer
  end
end
