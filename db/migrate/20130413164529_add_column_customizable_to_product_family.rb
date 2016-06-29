class AddColumnCustomizableToProductFamily < ActiveRecord::Migration
  def change
  	add_column :product_families, :additional_family, :boolean, :default => false
  end
end