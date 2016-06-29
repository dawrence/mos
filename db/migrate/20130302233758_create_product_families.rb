class CreateProductFamilies < ActiveRecord::Migration
  def change
    create_table :product_families do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
