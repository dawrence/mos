class CreateUserKitchens < ActiveRecord::Migration
  def change
    create_table :user_kitchens do |t|
      t.integer :user_id
      t.integer :kitchen_id

      t.timestamps
    end
  end
end
