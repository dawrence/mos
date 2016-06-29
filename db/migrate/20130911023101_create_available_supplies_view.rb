class CreateAvailableSuppliesView < ActiveRecord::Migration
  def up
  	execute <<-SQL
  	   create or replace view inventory
  	   as
  	   select inventory_movements.supply_id as supply_id        ,
              supplies."name"               as supply_name      ,
       SUM( CASE
              WHEN inventory_movements.movement_type = 'out' THEN
                   - inventory_movements.quantity
              WHEN inventory_movements.movement_type = 'in' THEN
                    inventory_movements.quantity
              ELSE 0
            END
          ) as supply_availability 
			   from inventory_movements INNER JOIN supplies on inventory_movements.supply_id = supplies."id"
			  group by inventory_movements.supply_id , 
			           supplies."name"
  	SQL
  end

  def down
  	execute <<-SQL
  	  drop view inventory
  	SQL
  end
end
