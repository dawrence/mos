class CreateRolesByUser < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.string :identifier
      t.timestamps
    end
    create_table :privileges do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :log_id
      t.timestamps
    end
  end
end