class AddColumnAdditionableToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :addittional, :boolean
  	add_column :products, :modificable, :boolean
  end
end
