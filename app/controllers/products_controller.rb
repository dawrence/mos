class ProductsController < ApplicationController
  
	def show_ingredients
    @menu_product = MenuProduct.includes(:products).find(params[:id])
    @product  =  @menu_product.products.includes(ingredients: :supply).original
    respond_to do |format|
      format.js
      format.html
    end
	end

	def check_availability
    @product = Product.find(params[:id])
    bill_id =  params[:bill_id] ? params[:bill_id] : 0
    @supplies = Array.new
    @notice = t(:this_product)+@product.menu_product.name.titleize+t(:theres_no_product)
    @vld = true
    if INVENTORY
        @product.ingredients.where(quantifiable:true).each do |i|
        	inv_supply = Inventory.find_by_supply_id(i.supply_id) != nil ?
                       Inventory.find_by_supply_id(i.supply_id).supply_availability : 0                
          supply = Supply.get_supplies_sumarize(["queue"],get_today_default_range[:init_date],get_today_default_range[:end_date],i.supply_id,bill_id)          
          que_supply =  if supply && !supply.empty?
                          supply.first.available_quantity.to_i
                        else
                          0
                        end                     
        	@supplies << {quantity: i.quantity.to_i, inventory: (inv_supply - que_supply).to_i}
      end
    end
    @supplies = @supplies.to_json
    respond_to do |format|
      format.js
    end
  end

end
