class CreateInventoryMovements < ActiveRecord::Migration
  def change
    create_table :inventory_movements do |t|
      t.integer :suply_id
      t.string :movement_type
      t.float :quantity
      t.text :description

      t.timestamps
    end
    add_index :inventory_movements, :suply_id
  end
end
