class CreateProductKitchens < ActiveRecord::Migration
  def change
    create_table :product_kitchens do |t|
      t.integer :product_id
      t.integer :kitchen_id

      t.timestamps
    end
  end
end
