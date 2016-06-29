class CreateAdditionals < ActiveRecord::Migration
  def change
    create_table :additionals do |t|
    	t.integer :product_id
      t.integer  :additional_id
      t.timestamps
    end
    add_index :additionals, :product_id
    add_index :additionals, :additional_id
  end
end
