class FixQueueProductsView < ActiveRecord::Migration
  def up
  	execute <<-SQL
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

  def down
  	execute <<-SQL
  		drop view queue_products
  	SQL
  end
end
