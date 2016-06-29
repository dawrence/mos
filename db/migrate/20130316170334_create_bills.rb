class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :status
      t.integer :table_id
      t.float :price

      t.timestamps
    end
    add_index :bills, :table_id
  end
end
