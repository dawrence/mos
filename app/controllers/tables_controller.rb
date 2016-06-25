class TablesController < ApplicationController
  # GET /tables
  # GET /tables.json
  def privileges
    [{generic: [:tables_management]}]
  end

  def index
    @tables = Table.includes(:bills).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tables }
    end
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    @table = Table.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table }
    end
  end

  # GET /tables/new
  # GET /tables/new.json
  def new
    @table = Table.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table }
    end
  end

  # GET /tables/1/edit
  def edit
    @table = Table.find(params[:id])
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(params[:table])

    respond_to do |format|
      if @table.save
        format.html { redirect_to tables_path, notice: 'Table was successfully created.' }
        format.json { render json: @table, status: :created, location: @table }
      else
        format.html { render action: "new" }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tables/1
  # PUT /tables/1.json
  def update
    @table = Table.find(params[:id])

    respond_to do |format|
      if @table.update_attributes(params[:table])
        format.html { redirect_to tables_path, notice: 'Table was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table = Table.find(params[:id])
    if @table.bills.all.empty?
      @table.destroy
      respond_to do |format|
        format.html { redirect_to tables_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tables_url, notice: "Cannot erase table. Has bills"}
        format.json { head :no_content }
      end
    end
  end

  def group_bills
    ActiveRecord::Base.transaction do
      table = Table.includes(bills: :orders).find(params[:id])
      bill = Bill.new(table_id: table.id, note: "Bill agrupada automaticamente")
      table.bills.where(status:["prepared","queue"]).each do |b|
        bill.add_bill(b)
      end
      respond_to do |format|
        format.html { redirect_to bills_path, notice: 'Agrupado!' }
        format.json { render json: @bill, status: :created, location: @bill }
      end
    end
  rescue ActiveRecord::RecordInvalid => exception
    respond_to do |format|
      format.html { redirect_to bills_path, notice: 'Fail!', status: 404 }
      format.json { render json: @bill, status: :created, location: @bill }
    end
  end

end
