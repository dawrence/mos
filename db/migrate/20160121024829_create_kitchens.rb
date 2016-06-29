class CreateKitchens < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|
      t.string :name
      t.string :short_name
      t.string :description

      t.timestamps
    end
  end
end
