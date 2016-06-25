class SuppliesController < ApplicationController
  # GET /supplies
  # GET /supplies.json
  def privileges
    [{generic: [:product_management]},
    {action: "supplies_sumarize", validations: [:supplies_history]}]
  end


  def index
    @supplies = Supply.includes(:supply_category).all
    @supply_category = SupplyCategory.includes(:supplies).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supplies }
    end
  end

  # GET /supplies/1
  # GET /supplies/1.json
  def show
    @supply = Supply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @supply }
    end
  end

  # GET /supplies/new
  # GET /supplies/new.json
  def new
    @supply_category = SupplyCategory.find(params[:sc_id])
    @supply = @supply_category.supplies.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supply }
    end
  end

  # GET /supplies/1/edit
  def edit
    @supply = Supply.find(params[:id])
  end

  # POST /supplies
  # POST /supplies.json
  def create
    @supply = Supply.new(params[:supply])

    respond_to do |format|
      if @supply.save
        format.html { redirect_to supplies_path, notice: 'Supply was successfully created.' }
        format.json { render json: @supply, status: :created, location: @supply }
      else
        format.html { render action: "new" }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /supplies/1
  # PUT /supplies/1.json
  def update
    @supply = Supply.find(params[:id])

    respond_to do |format|
      if @supply.update_attributes(params[:supply])
        format.html { redirect_to supplies_path, notice: 'Supply was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  def supplies_sumarize
    if params[:init_date] && params[:end_date] && params[:status]
      setting=Setting.getSetting()
      cutoff_hour = setting.cutoff_date.hour
      init_date = DateTime.strptime(params[:init_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
      end_date = DateTime.strptime(params[:end_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
      @supplies = Supply.get_supplies_sumarize(params[:status],init_date,end_date)
      @vld = true
      @notice = "Consulta exitosa"
    else
      @vld = false
      @notice = "Error. No se seleccionaron fechas y/o estados"
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

  # DELETE /supplies/1
  # DELETE /supplies/1.json
  def destroy
    @supply = Supply.find(params[:id])
    @supply.destroy

    respond_to do |format|
      format.html { redirect_to supplies_url }
      format.json { head :no_content }
    end
  end
end
