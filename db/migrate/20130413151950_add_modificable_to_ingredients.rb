class AddModificableToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :modificable, :boolean, :default => true
  end
end
