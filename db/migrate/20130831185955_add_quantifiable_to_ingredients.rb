class AddQuantifiableToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :quantifiable, :boolean, default:false
  end
end
