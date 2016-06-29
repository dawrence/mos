class AddColumnRoleToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :role, :integer, default:2
  end
end
