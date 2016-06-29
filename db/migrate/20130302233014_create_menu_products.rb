class CreateMenuProducts < ActiveRecord::Migration
  def change
    create_table :menu_products do |t|
      t.string :name
      t.integer :product_family_id
      t.text :description

      t.timestamps
    end
    add_index :menu_products, :product_family_id
  end
end
