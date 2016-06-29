class AddColumnTypeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :role_type, :string, default: ""
  end
end
