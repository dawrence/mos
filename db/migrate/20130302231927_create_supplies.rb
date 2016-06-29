class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.integer :supply_category_id
      t.float :availability

      t.timestamps
    end
    add_index :supplies, :supply_category_id
  end
end
