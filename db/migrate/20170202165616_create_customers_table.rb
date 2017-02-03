class CreateCustomersTable < ActiveRecord::Migration
  def change
  	create_table :customers do |t|
      t.text :national_id
      t.text :name
      t.text :last_name
      t.text :tel
      t.text :email
      t.text :address
      t.integer :ocurrences
      t.boolean :confirmed
      t.timestamps
    end
    add_index :customers, :national_id
    add_index :customers, :id
  end
end
