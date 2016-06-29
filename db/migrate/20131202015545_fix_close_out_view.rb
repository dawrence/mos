class FixCloseOutView < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		create or replace view paid_products
  		as 
  		select products.menu_product_id as product_id,
			       menu_products."name" as product_name,
			       bills.updated_at as order_date,
			       products.price as price, 
			       (count(products.menu_product_id) * orders.quantity) as size 
			  from bills inner join orders on orders.bill_id = bills."id" 
			             inner join products on products."id" = orders.product_id
			             inner join menu_products on products.menu_product_id = menu_products."id"
			 where bills.status = 'paid' 
			 group by products.menu_product_id,
			          menu_products."name",
			          bills.updated_at,
			          products.price,
			          orders.quantity
			UNION
      select products.menu_product_id as product_id,
			       menu_products."name" as product_name,
			       bills.updated_at as order_date,
			       products.price as price, 
			       (count(products.menu_product_id) * additionals.quantity)  as size 
        from bills inner join orders on orders.bill_id = bills."id" 
			             inner join additionals on additionals.product_id = orders.product_id
                   inner join products on additionals.additional_id = products."id"
			             inner join menu_products on products.menu_product_id = menu_products."id"
       where bills.status = 'paid' 
       group by products.menu_product_id,
			          menu_products."name",
			          bills.updated_at,
			          products.price, 
			          additionals.quantity;
  	SQL
  end

  def down
  	 execute <<-SQL
  	 	drop view paid_products
  	 SQL
  end
end
