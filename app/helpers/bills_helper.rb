module BillsHelper

	def product_original_to_order(product,quantity = 1)
		render "products/order_templates/original_to_order", product: product, quantity: quantity
	end
  
  def add_product_link(pf, i="",b_id=0)
  	result = "<ul id='#{pf.name.parameterize}_products' class='productPicking'>"
  	pf.products.includes(:menu_product).each do |mp|
      field = product_original_to_order(mp)
  	  result += "<li>"+link_to(mp.menu_product.name, vld_prod_path(id:mp.id,bill_id: b_id),remote:true,class: 'to_order_product')+"</li>"
  	end
  	result += "</ul>"
  	return result
  end
 
  def additional_products(additional,quantity=1)
    render "products/order_templates/additionals", additional: additional, quantity: quantity
  end

  def show_product_custom_ingredients(product,none_display=false)
    render("products/order_templates/product_custom_ingredients", product: product, none_display: none_display)
  end

  def show_products_attributes(product)
      result = ""
      ingredients = Array.new(0)
      o_ing = product.menu_product.products.original.ingredients
      c_ing = product.ingredients
      o_ing.each{|i| ingredients << {ingredient: i, selected: ((c_ing.find{|j| j.supply_id == i.supply_id} != nil)? true : false)}}
      ingredients.each do |i|        
        result += render("products/order_templates/product_attributes", i: i, product: product)
      end
      return result;
  end
  
  def show_alert(message)
    message
  end

  #kill Bill by David!! .l. xD .l.
  def render_bill(bill,print_date=false,show_price_details=false, last_status=false)
    render "bills/on_tables/bill_row", bill: bill, print_date: print_date, show_price_details: show_price_details, last_status: last_status
  end

end

