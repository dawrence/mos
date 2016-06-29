class FixModificableAdditionalToProducts < ActiveRecord::Migration
  def up
  	add_column :menu_products, :additional, :boolean,  default:false
  	add_column :menu_products, :modificable, :boolean, default:false
  end

  def down
  	remove_column :menu_products, :additional
  	remove_column :menu_products, :modificable
  end
end
