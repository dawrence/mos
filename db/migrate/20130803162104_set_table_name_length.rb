class SetTableNameLength < ActiveRecord::Migration
  def up
  	change_column :tables, :name, :string, limit: 3
  end

  def down
  	change_column :tables, :name, :string
  end
end
