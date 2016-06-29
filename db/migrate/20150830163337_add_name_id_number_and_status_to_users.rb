class AddNameIdNumberAndStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :status, :string
    add_column :users, :id_number, :string
  end
end
