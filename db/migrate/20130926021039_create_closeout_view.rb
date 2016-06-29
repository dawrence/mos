class CreateCloseoutView < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		create or replace view paid_products
  		as 
  		select products.menu_product_id as product_id,
			       menu_products."name" as product_name,
			       bills.updated_at as order_date,
			       sum(products.price) as price, 
			       count(products.menu_product_id) as size 
			  from bills inner join orders on orders.bill_id = bills."id" 
			             inner join products on products."id" = orders.product_id
			             inner join menu_products on products.menu_product_id = menu_products."id"
			 where bills.status = 'paid' 
			 group by products.menu_product_id,
			          menu_products."name",
			          bills.updated_at
  	SQL
  end

  def down
  	 execute <<-SQL
  	 	drop view paid_products
  	 SQL
  end
  
end
