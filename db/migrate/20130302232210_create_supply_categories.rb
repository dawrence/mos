class CreateSupplyCategories < ActiveRecord::Migration
  def change
    create_table :supply_categories do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
