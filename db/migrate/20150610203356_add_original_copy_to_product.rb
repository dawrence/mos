class AddOriginalCopyToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :original_copy, :boolean, default: false
  end
end
