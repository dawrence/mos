class BillsController < ApplicationController
  before_filter :validate_user_actions
  layout false, only: [:print,:z_report]
  
  def privileges
    [{generic: [:bills_edition]},
    {action: "cancel_form", validations:[:bills_edition]},
    {action: "destroy", validations:[:bills_edition]},
    {action: "prepared_bill", validations:[:bills_edition,:bills_prepared]},
    {action: "closeout", validations: [:bills_edition, :closeout_report]},
    {action: "print",validations:[:bills_edition,:bills_print]},
    {action: "z_report",validations:[:bills_edition,:bills_z_report]},
    {action: "pending_bill",validations:[:bills_edition,:bills_pending]},
    {action: "bills_report", validations:[:bills_edition,:bills_reports_history]}]
  end

  def submit_split
    Bill.find(params[:id]).split(params[:bill][:orders])
    respond_to do |format|
      format.html { redirect_to bills_path, notice: 'Bill was successfully created.' }
      format.json { render json: @bill, status: :created, location: @bill }
    end    
  end

  def notify_error(message,action="")
    @vld = false
    @notice = message
    respond_to do |format|
          format.html { redirect_to root_path, notice:message}
          format.json { render json: @bill.errors, status: :unprocessable_entity }
          format.js { render action: action}
    end
  end

  def validates
    @bill = Bill.find(params[:id])
    @notice = t(:being_updated)
    respond_to do |format|
      format.js 
    end
  end

  def send_response(action,message=nil)
    @action = action
    @notice = message
    respond_to do |format|
      format.js { render :action => "action.js.erb"}
    end
  end

  def index
    today_default_range = get_today_default_range
    @aux_tables = Table.includes(:active_bills).aux
    @normal_tables = Table.includes(:active_bills).normal
    @bills = Bill.includes(:table).active
    @products = QueueProduct.all
    @all_supplies = Supply.get_supplies_sumarize(["queue"],get_today_default_range[:init_date],get_today_default_range[:end_date])
    @pending_bills = Bill.get_pending()
    @bills_paid = Bill.get_current_paid()
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  def split
    @bill = Bill.find(params[:id])
  end
  

  def cancel_form
    @bill = Bill.find(params[:id])  
    # validates for lock
    if (allowed?(:bills_nullify) or allowed?(:bills_queue_null))
      if @bill.is_unlocked
        @vld = true
      elsif !@bill.is_unlocked
        @notice = t(:being_updated)
        @vld = false
      end
    else
      @notice = "No esta autorizado."
      @vld = false
    end  
    respond_to do |format|
      format.js
    end 
    #rescue Exception
    #@vld = false
    #@notice = t(:forget_to_refresh)
    #respond_to do |format|
    #  format.js
    #end    
  end

  
  # GET /bills/1
  # GET /bills/1.json
  def show
    @bill = Bill.includes([
      :orders,
      {
        products: [
          :ingredients,
          :supplies,
          {
            additionals: [{additional: :menu_product }]
          },
          {menu_product: :product}
        ]
      },
      :table]).find(params[:id])
    @vld = true
    respond_to :js
  end

  def new
    @table = Table.find(params[:table_id])
    @bill = @table.bills.new 
    @product_families = ProductFamily.where(additional_family: false)
    @additional_class = ProductFamily.additionals.first
  end

  def edit
    @bill = Bill.includes(:orders).find(params[:id])
    if @bill.is_unlocked && @bill.status == 'queue'
      @orders = @bill.orders
      @product_families = ProductFamily.where(additional_family: false)
      @additional_class = ProductFamily.additionals.first    
      @bill.updated_mk = true
      @bill.user = current_user
      @bill.save
    elsif !@bill.is_unlocked
      notify_error(t(:being_updated))
    elsif @bill.status != 'queue'
      notify_error(t(:forget_to_refresh))
    end
  rescue Exception
    notify_error(t(:forget_to_refresh))
  end

  def update_table
    @bill  = Bill.find(params[:bill_id])
    if @bill.is_unlocked 
      if params[:table_id] != nil
        @bill.table_id = params[:table_id]
        respond_to do |format|
          ActiveRecord::Base.record_timestamps = false
          if @bill.save 
            ActiveRecord::Base.record_timestamps = true 
            format.html { redirect_to bills_path, notice: 'Bill was successfully created.' }
            format.json { render json: @bill, status: :created, location: @bill }
          else
            ActiveRecord::Base.record_timestamps = true
            format.html { render action: "show" }
            format.json { render json: @bill.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { render action: "show", notice:"no table was selected"}
          format.json { render json: @bill.errors, status: :unprocessable_entity }
        end
      end
    else
      notify_error(t(:being_updated))
    end
  rescue Exception
    ActiveRecord::Base.record_timestamps = true
    notify_error(t(:forget_to_refresh))
  end

  def edit_table
    @bill = Bill.find(params[:bill_id])
    @tables = Table.all
    @notice = t(:being_updated)
    respond_to :js
  end

  def create
    o_at = params[:bill][:orders_attributes]
    if o_at != nil
      o_at.select{|o| o[:product_attributes] != nil }.each{|x| x.delete(:product_attributes) if(x[:product_attributes][:ingredients_attributes] == nil && x[:product_attributes][:additionals_attributes] == nil)}
      o_at.select{|o| o[:product_attributes] != nil}.each do |x| 
        if its_original(MenuProduct.find(x[:product_attributes][:menu_product_id]),x[:product_attributes][:ingredients_attributes]) &&  x[:product_attributes][:additionals_attributes] == nil
          x.delete(:product_attributes) 
        end      
      end
      o_at.select{|o| o[:product_attributes] != nil }.each{|x| x.delete(:product_id)}
      
      o_ing = o_at.select{|o| o[:product_attributes] != nil}
      o_ing.each do |z| 
        if z[:product_attributes][:ingredients_attributes] != nil
            z[:product_attributes][:ingredients_attributes].select{|x| x[:quantity] == "0"}.each{|y| z[:product_attributes][:ingredients_attributes].delete(y)} 
        end
        if  z[:product_attributes][:ingredients_attributes] == nil  &&  z[:product_attributes][:additionals_attributes] != nil
          ing_att = Array.new(0)
          MenuProduct.find(z[:product_attributes][:menu_product_id]).product.ingredients.each do |p_i|
            ing_att +=[{quantity:p_i.quantity.to_s, supply_id:p_i.supply_id.to_s, quantifiable: p_i.quantifiable}]
          end
          z[:product_attributes][:ingredients_attributes] = ing_att
        end
      end
      orders = Array.new(0)
      params[:bill][:orders_attributes].each do |o|
        result = orders.find{|h| h[:product_id] == o[:product_id] && o[:product_id] != nil}
        result != nil ? result[:quantity] = (result[:quantity].to_i + 1) : orders += [o]
      end

      params[:bill][:orders_attributes] = orders
      params.delete(:ingredient)

      

      price =0      
      params[:bill][:orders_attributes].each do |o|
        if o[:product_id] 
           o[:unit_price]  = Product.find(o[:product_id]).price.to_f 
           price += o[:unit_price] * o[:quantity].to_i
        else
          additional_price = 0
          o[:unit_price] = o[:product_attributes][:price].to_f 
          price += o[:product_attributes][:price].to_f * o[:quantity].to_i
          if  o[:product_attributes][:additionals_attributes]
            o[:product_attributes][:additionals_attributes].each do |a|
              a[:unit_price] = Product.find(a[:additional_id]).price.to_f 
              additional_price += a[:unit_price] * a[:quantity].to_i
            end
          end
          price += additional_price
        end                
      end
      
      params[:bill][:price] = price

      
      Bill.transaction do
        @bill = Bill.new(params[:bill])
        @bill.price = 0 if @bill.price == nil
        @orders =  @bill.orders.build
        now_s = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        bool = Bill.where("date_trunc('second',created_at) = '#{now_s}' AND 
                           user_id = #{@bill.user_id}")
        success = bool.empty? ?  @bill.save! : false
        @vld = true
        @notice = "Comanda creada satisfactoriamente"
        if success
          if !@bill.validate_bill(@bill.id)
            @vld = false
            puts "this is #{@bill.errors.messages}"
            @notice =@bill.errors.full_messages.sum{|d| d.to_s}
            @bill.errors.clear
            raise ActiveRecord::Rollback  
          end                                   
        elsif !bool.empty?
            @vld = false
            @notice = "Ya existe la factura"
        else
          @vld = false
          @notice = "Error"
        end    
      end
      
      
    else
      @vld = false
      @notice =  t(:bill_not_created)
    end
    respond_to do |format|
      format.js {render action: "form"}
    end
  rescue => e
    @vld = false
    @notice =  e.message
    respond_to do |format|
      format.js {render action: "form"}
    end
  end

  def its_original(mp,ingredients)
    ing = Array.new(0)
    o_ing = mp.products.original.ingredients
    if ingredients != nil
      o_ing.each do |i| 
        if (ingredients.find{|j| j[:supply_id].to_s == i.supply_id.to_s && j[:quantity].to_f == i.quantity.to_f} == nil)
          return false
        end
      end
    end
    return true
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    o_at = params[:bill][:orders_attributes]
    @bill = Bill.find(params[:id])
    @bill.updated_mk = false if @bill.user_id == current_user.id

    if @bill.is_unlocked && @bill.status == 'queue'
      if o_at != nil
        o_at.select{|o| o[:product_attributes] != nil}.each{|x| x.delete(:product_attributes) if(x[:product_attributes][:ingredients_attributes] == nil && x[:product_attributes][:additionals_attributes] == nil)}
        o_at.select{|o| o[:product_attributes] != nil}.each do |x| 
          if its_original(MenuProduct.find(x[:product_attributes][:menu_product_id]),x[:product_attributes][:ingredients_attributes]) &&  x[:product_attributes][:additionals_attributes] == nil
            x.delete(:product_attributes) 
          end
        end
        
        o_at.select{|o| o[:product_attributes]!= nil}.each{ |x| x.delete(:product_id)}
        
        o_ing = o_at.select{|o| o[:product_attributes] != nil}
        o_ing.each do |z| 
          if z[:product_attributes][:ingredients_attributes] != nil
             z[:product_attributes][:ingredients_attributes].select{|x| x[:quantity] == "0"}.each{|y| z[:product_attributes][:ingredients_attributes].delete(y)} 
          end
          if  z[:product_attributes][:ingredients_attributes] == nil  &&  z[:product_attributes][:additionals_attributes] != nil
            ing_att = Array.new(0)
            MenuProduct.find(z[:product_attributes][:menu_product_id]).products.original.ingredients.each do |p_i|
              ing_att +=[{quantity:p_i.quantity.to_s, supply_id:p_i.supply_id.to_s, quantifiable: p_i.quantifiable}]
            end
            z[:product_attributes][:ingredients_attributes] = ing_att
          end
        end

        orders = Array.new(0)
        params[:bill][:orders_attributes].each do |o|
          result = orders.find{|h| h[:product_id] == o[:product_id] && o[:product_id] != nil}
          result != nil ? result[:quantity] = (result[:quantity].to_i + 1) : orders += [o]
        end

        params[:bill][:orders_attributes] = orders
        params.delete(:ingredient)
        success = false

        price =0
        params[:bill][:orders_attributes].each do |o|
          if o[:product_id] 
             o[:unit_price]  = Product.find(o[:product_id]).price.to_f 
             price += o[:unit_price] * o[:quantity].to_i
          else
            additional_price = 0
            o[:unit_price] = o[:product_attributes][:price].to_f 
            price += o[:product_attributes][:price].to_f * o[:quantity].to_i
            if  o[:product_attributes][:additionals_attributes]
              o[:product_attributes][:additionals_attributes].each do |a|
                a[:unit_price] = Product.find(a[:additional_id]).price.to_f 
                additional_price += a[:unit_price] * a[:quantity].to_i
              end
            end
            price += additional_price
          end                
        end
        params[:bill][:price] = price        

        Bill.transaction do           
          @bill.orders.each{|d| d.destroy}
          @bill.save!
          @bill =Bill.find(params[:id])
          @vld = true
          @notice = t(:bill_succesful) 
          success = @bill.update_attributes!(params[:bill])          
          if success
            @bill.price = 0 if @bill.price == nil
            @bill.updated_mk = false
            if !@bill.validate_bill(@bill.id)
              @vld = false
              @notice =@bill.errors.full_messages.sum{|d| d.to_s}
              @bill.errors.clear
              raise ActiveRecord::Rollback
            end
          else
              @vld = false
              
              @notice =@bill.errors.full_messages.sum{|d| d.to_s}
              raise ActiveRecord::Rollback
          end          
        end
      else
        @vld = false
        @notice =  t(:bill_not_updated)
      end
    elsif !@bill.is_unlocked
      @vld = false
      @notice =  t(:being_updated)      
    elsif @bill.status != 'queue'
      @vld = false
      @notice =  "El pedido no se puede editar por el estado"
    end
    respond_to do |format|
      format.js {render action: "form"}
    end
  
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy    
    @bill = Bill.find(params[:id])
    if @bill.is_unlocked
      #@bill.destroy
      if (@bill.status.to_sym == :queue && allowed?(:bills_queue_null)) ||
         (@bill.status.to_sym == :prepared && allowed?(:bills_nullify))
        @bill.cancel(params[:note])
        @vld = true
        @notice = t(:succesfull_destroy)
      else
        @vld = false
        @notice = "No esta autorizado"
      end
      
    else
      @vld = false
      @notice = t(:being_updated)
    end
    respond_to do |format|
        format.js 
    end
  rescue => e
    @vld = false
    @notice = e.message
    respond_to do |format|
        format.js 
    end
  end

  def prepared_bill 
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
      :discount_voucher]).find(params[:id])

    if bill.prepare_by_kitchen(nil, current_user.id,"#{current_user.email}:#{current_user.id}.")
      redirect_to bills_url
    elsif !bill.is_unlocked
      notify_error(t(:being_updated))
    elsif bill.status != 'queue'
      notify_error(t(:forget_to_refresh))
    end
  
  end 

  def closeout
    if !params[:init_date].empty? &&
       !params[:end_date].empty?
       @vld = true
       @products = PaidProduct.retrieve(params[:init_date], params[:end_date])       
       @price = @products.sum{|p| (p.unit_price.to_f == 0 ? p.product_price.to_f : p.unit_price.to_f) * p.cnt.to_i}
    else
      @vld = false
      @notice= t(:no_date_selected)
    end
    respond_to do |format|
      format.js
    end
  
  end

  def print
    @bill = Bill.includes([
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
    @setting = Setting.getSetting()
    respond_to do |format|
      format.html # print.html.erb
    end
  end

  def z_report
    @setting = Setting.getSetting()
    z_day = Time.strptime(params[:z_day],"%m/%d/%Y").in_time_zone("America/Bogota")
    cutoff_hour = @setting.cutoff_date.hour
    now = z_day - cutoff_hour.hours
    first_date = now.change(hour: cutoff_hour)
    last_date = now.change(hour: cutoff_hour) + 1.day
    @z_date = last_date
    @bills = Bill.where(updated_at: first_date..last_date, status: "paid", payment_type: ["cash", "card"]).reorder("bills.billing_number ASC")
    @total_card = @bills.sum{|p| p.payment_type.to_sym == :card ? p.getTotal().to_f : 0}
    @total_cash = @bills.sum{|p| p.payment_type.to_sym == :cash ? p.getTotal().to_f : 0}
    @sum_subtotal = @bills.sum{|p| p.price.to_f }
    @sum_total = @bills.sum{|p| p.getTotal().to_f }
    @sum_impc = @bills.sum{|p| p.tax.to_f }

    if !@bills.empty?
      respond_to do |format|
        format.html # print.html.erb
      end
    else
      notify_error("No hay facturas pagadas para el dia seleccionado")
    end
  rescue => e
    notify_error("Ocurrio un error #{e.message}")
  end


  def pending_bill    
    bill = Bill.find(params[:id])
    bill.pending
    respond_to do |format|
      format.html {redirect_to bills_path, notice: "Comanda modificada" }
    end
  rescue => e
    notify_error(e.message)
  end

  def bills_report 
    #raise params.to_yaml    
    if !params[:init_date].empty? &&
       !params[:end_date].empty?
       @vld = true
       @table = Table.find(params[:table_id]) if params[:table_id] && params[:table_id] != ""
       selected_status = params[:status]
       setting=Setting.getSetting()
       cutoff_hour = setting.cutoff_date.hour
       init_date = DateTime.strptime(params[:init_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
       end_date = DateTime.strptime(params[:end_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
       payment_type_selected = params[:payment_type]
       @bills=  if @table 
                  Bill.where(updated_at: init_date..end_date,table_id: @table.id, status: selected_status, payment_type: payment_type_selected)
                else
                  Bill.where(updated_at: init_date..end_date, status: selected_status, payment_type: payment_type_selected  )
                end       
       @price = @bills.sum{|b| b.total.to_f}
       @total_queue    = @bills.sum{|b| b.status == "queue" ?    b.price.to_f : 0 }
       @total_prepared = @bills.sum{|b| b.status == "prepared" ? b.price.to_f : 0 }
       @total_paid     = @bills.sum{|b| b.status == "paid" ?     b.total.to_f : 0  }
       @total_tip    = @bills.sum{|b| b.status == "paid" ?     b.tip.to_f : 0  }
       @total_discount    = @bills.sum{|b| b.status == "paid" ?     b.discount_value.to_f : 0  }
       @total_canceled = @bills.sum{|b| b.status == "canceled" ? b.price.to_f : 0  }
    else
      @vld = false
      @notice= t(:no_date_selected)
    end
    respond_to do |format|
      format.js
    end
  rescue => e
    @vld = false
    @notice = e.message
    respond_to do |format|
      format.js
    end
  end

end
