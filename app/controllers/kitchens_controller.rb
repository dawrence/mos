class KitchensController < ApplicationController

	layout Proc.new {|controller| ["show","control_kitchen"].include?(controller.action_name) ? "kitchen" : "application"}

	def privileges
        [
        	{generic:[:kitchen_management]},
        	{action: "control_kitchen", validations:[:view_kitchen]},
        	{action: "remove_bill", validations:[:view_kitchen]},
        	{action: "reload_kitchen", validations:[:view_kitchen]},
        	{action: "show", validations:[:view_kitchen]}
    	]
    end

    def show
    	@bills = get_bills
    end
    def control_kitchen
		@bills = get_bills
	end

	def index
		@kitchens = Kitchen.all
		respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: @kitchens }
	    end
	end

	def edit
		@kitchen = Kitchen.find(params[:id])
		respond_to do |format|
	      format.html # edit.html.erb
	      format.json { render json: @kitchen }
	    end
	end

	def update
		@kitchen = Kitchen.find(params[:id])
		respond_to do |format|
		  if @kitchen.update_attributes(params[:kitchen])
		    format.html { redirect_to kitchens_path, notice: 'Cocina actualizada' }
		    format.json { render json: @kitchen, status: :created, location: @kitchen }
		  else
		    format.html { render action: "update" }
		    format.json { render json: @kitchen.errors, status: :unprocessable_entity }
		  end
		end
	end

	def destroy
		Kitchen.find(params[:id]).destroy
		respond_to do |format|
            format.html { redirect_to kitchens_url }
            format.json { head :no_content }
        end
	end

	def new
		@kitchen = Kitchen.new
		respond_to do |format|
	      format.html # edit.html.erb
	      format.json { render json: @kitchen }
	    end
	end

	def create
		@kitchen = Kitchen.new(params[:kitchen])
		respond_to do |format|
		  if @kitchen.save
		    format.html { redirect_to kitchens_path, notice: 'Cocina creada' }
		    format.json { render json: @kitchen, status: :created, location: @kitchen }
		  else
		    format.html { render action: "new" }
		    format.json { render json: @kitchen.errors, status: :unprocessable_entity }
		  end
		end
	end

	
	def remove_bill
		bill = Bill.includes([
                            :orders,
                            {
                              products: 
                                [
                                  :ingredients,
                                  :supplies,
                                  {
                                    additionals: 
                                    [{additional: :menu_product}]
                                  },
                                  { menu_product: :product}
                                ]
                            },
                            :table,
                            :discount_voucher
                            ]).find(params[:id])
		if bill.prepare_by_kitchen(params[:kitchen_id], current_user.id,"#{current_user.email}:#{current_user.id}.")
		  redirect_to control_kitchen_path(id: params[:kitchen_id]), alert: t(:outgoing_by_bills)
		else
		  redirect_to control_kitchen_path(id: params[:kitchen_id]), alert: t(:being_updated)
    end

	end	

	def reload_kitchen
		@bills = get_bills
	end

	private

	def get_bills
		Bill.includes([
	                      :orders,
                          {
                          	products: 
                  	          [
                  	          	:ingredients,
                  	            :supplies,
                  	            {
                  	            	additionals: 
                  	           	  [{additional: :menu_product}]
                  	            },
                  	            :menu_product
                  	          ]
                          },
                          :table
                          ]).get_by_kitchen(params[:id])		
	end

end