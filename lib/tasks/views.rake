namespace :views do
	desc "initialize db views"
	task :queue_products => [:environment] do
		ActiveRecord::Base.connection.execute <<-SQL
	  	create or replace view queue_products
	  	as
	  	  select products.menu_product_id as product_id,
				       menu_products."name" as product_name,
				       sum(products.price * orders.quantity) as price, 
				       sum(orders.quantity) as size 
				  from bills inner join orders on orders.bill_id = bills."id" 
				             inner join products on products."id" = orders.product_id
				             inner join menu_products on products.menu_product_id = menu_products."id"
				 where bills.status = 'queue' 
				 group by products.menu_product_id,
				          menu_products."name"                                          
  		SQL
  	end
	task :paid_products => [:environment] do
	  	ActiveRecord::Base.connection.execute <<-SQL
		  		create view paid_products
		  		as 
		  		select products.menu_product_id as product_id,
					       menu_products."name" as product_name,
					       bills.updated_at as order_date,
					       orders.unit_price as unit_price,
					       products.price as product_price, 
					       (count(products.menu_product_id) * orders.quantity) as size 
					  from bills inner join orders on orders.bill_id = bills."id" 
					             inner join products on products."id" = orders.product_id
					             inner join menu_products on products.menu_product_id = menu_products."id"
					 where bills.status = 'paid' 
					   and bills.payment_type IN ('cash', 'card')
					 group by products.menu_product_id,
					          menu_products."name",
					          bills.updated_at,
					          orders.unit_price,
					          products.price,
					          orders.quantity
					UNION
		      select products.menu_product_id as product_id,
					       menu_products."name" as product_name,
					       bills.updated_at as order_date,
					       additionals.unit_price as unit_price, 
					       products.price as product_price,
					       (count(products.menu_product_id) * additionals.quantity)  as size 
		        from bills inner join orders on orders.bill_id = bills."id" 
					             inner join additionals on additionals.product_id = orders.product_id
		                   inner join products on additionals.additional_id = products."id"
					             inner join menu_products on products.menu_product_id = menu_products."id"
		       where bills.status = 'paid' 
		         and bills.payment_type IN ('cash', 'card')
		       group by products.menu_product_id,
					          menu_products."name",
					          bills.updated_at,
					          additionals.unit_price, 
					          products.price,
					          additionals.quantity;
			SQL
	end
	task :inventories => [:environment] do 
	  	ActiveRecord::Base.connection.execute <<-SQL
	       create or replace view inventories
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
end