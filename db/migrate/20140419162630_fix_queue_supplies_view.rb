class FixQueueSuppliesView < ActiveRecord::Migration
  def up
  	execute <<-SQL
  	  create or replace view queue_supplies
  	  as
	  		select supplies."id"             as supply_id         ,
				       supplies."name"           as supply_name       ,
				       SUM(ingredients.quantity * orders.quantity) as available_quantity
				  from bills INNER JOIN orders on orders.bill_id = bills."id"
				             INNER JOIN products on products."id" = orders.product_id
				             INNER JOIN ingredients on ingredients.product_id = products."id"
				             INNER JOIN supplies    on supplies."id" = ingredients.supply_id 
				 where bills.status = 'queue'
				 group by supplies."name",
				          supplies."id"
				 order by supplies."name" ASC
  	SQL
  end

  def down
  	execute <<-SQL
  		drop view queue_supplies
  	SQL
  end
end
