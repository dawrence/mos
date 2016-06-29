class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :nit
      t.string :business_name
      t.string :address
      t.string :city
      t.string :telephone
      t.string :mail
      t.string :prefix
      t.integer :lower_range
      t.integer :upper_range
      t.integer :consumption_tax
      t.text :tip_text
      t.string :billing_system_resolution
      t.string :billing_resolution
      t.string :date

      t.timestamps
    end
  end
end
