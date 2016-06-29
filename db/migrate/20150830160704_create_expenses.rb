class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.text :description
      t.float :value
      t.string :receipt_number
      t.integer :user_id

      t.timestamps
    end
    add_index :expenses, :user_id
  end
end
