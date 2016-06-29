class RenameInventoryView < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		alter view inventory rename to inventories
  	SQL
  end

  def down
  	execute <<-SQL
  		alter view inventories rename to inventory
  	SQL
  end
end
