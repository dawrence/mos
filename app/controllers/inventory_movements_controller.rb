class InventoryMovementsController < ApplicationController
  # GET /inventory_movements
  # GET /inventory_movements.json
  def privileges
    [{generic: [:inventories_management]}]
  end


  def index
    @supply_categories = SupplyCategory.includes([supplies: :inventory]).all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_movements }
    end
  end

  # GET /inventory_movements/1
  # GET /inventory_movements/1.json
  def show
    @inventory_movement = InventoryMovement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_movement }
    end
  end

  # GET /inventory_movements/new
  # GET /inventory_movements/new.json
  def new
    @inventory_movement = InventoryMovement.new
    @supply = Supply.find(params[:id])
    respond_to do |format|
      format.js # new.html.erb
      format.json { render json: @inventory_movement }
    end
  end

  # GET /inventory_movements/1/edit
  def edit
    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @inventory_movement.errors, status: :unprocessable_entity }
    end
  end

  # POST /inventory_movements
  # POST /inventory_movements.json
  def create
    params[:inventory_movement][:user_id] = current_user.id
    @inventory_movement = InventoryMovement.new(params[:inventory_movement])

    respond_to do |format|
      if @inventory_movement.save
        format.html { redirect_to inventory_movements_path, notice: t(:inventory_created) }
        format.json { render json: @inventory_movement, status: :created, location: @inventory_movement }
      else
        format.html { redirect_to inventory_movements_path, notice: t(:inventory_not_created) }
        format.json { render json: @inventory_movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_movements/1
  # PUT /inventory_movements/1.json
  def update
    #@inventory_movement = InventoryMovement.find(params[:id])    
    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @inventory_movement.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /inventory_movements/1
  # DELETE /inventory_movements/1.json
  def destroy
    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @inventory_movement.errors, status: :unprocessable_entity }
    end
  end


  def details_by_supply
    @supply = Supply.find(params[:id])
    setting=Setting.getSetting()
    cutoff_hour = setting.cutoff_date.hour
    init_date = DateTime.strptime(params[:init_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
    end_date  = DateTime.strptime(params[:end_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
    params.delete(:user_id) if params[:user_id].to_i == -1
    params[:updated_at] = init_date...end_date if init_date && end_date
    @inv_by_spl = @supply.inventory_movements
                          .where(params.slice(:movement_type, :adjustment,:updated_at, :user_id))
                          .page(params[:page])
    @notice = t(:no_inventory_movements)
    respond_to do |format|
      format.js
    end
    rescue Exception
      @notice = "No se seleccionaron fechas"
      respond_to do |format|
        format.js
      end
  end

  def massive_insert
    #raise params.to_yaml
    ids = params[:supplies]
    ids.each do |id|
      type = params[:type][id][0]
      quantity = params[:quantity][id][0]
      adjustment = params[:adjustment] ? (params[:adjustment][id] ? params[:adjustment][id][0] : false ) : false
      InventoryMovement.create(supply_id: id, movement_type: type, quantity: quantity.to_f, adjustment: adjustment, description: "Entrada masiva de inventario", user_id: current_user.id)
    end
    @vld = true
    rescue Exception
      @vld = false 
      @notice = params.to_yaml
    ensure
      respond_to do |format|
        format.js
      end
  end

end
