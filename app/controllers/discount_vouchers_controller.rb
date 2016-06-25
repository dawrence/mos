class DiscountVouchersController < ApplicationController
  # GET /discount_vouchers
  # GET /discount_vouchers.json
  def privileges
    [{generic: [:discount_management]}]
  end
  def index
    @discount_vouchers = DiscountVoucher.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discount_vouchers }
    end
  end

  # GET /discount_vouchers/1
  # GET /discount_vouchers/1.json
  def show
    @discount_voucher = DiscountVoucher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discount_voucher }
    end
  end

  # GET /discount_vouchers/new
  # GET /discount_vouchers/new.json
  def new
    @discount_voucher = DiscountVoucher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discount_voucher }
    end
  end

  # GET /discount_vouchers/1/edit
  def edit
    @discount_voucher = DiscountVoucher.find(params[:id])
  end

  # POST /discount_vouchers
  # POST /discount_vouchers.json
  def create
    @discount_voucher = DiscountVoucher.new(params[:discount_voucher])

    respond_to do |format|
      if @discount_voucher.save
        format.html { redirect_to discount_vouchers_path, notice: 'Discount voucher was successfully created.' }
        format.json { render json: @discount_voucher, status: :created, location: @discount_voucher }
      else
        format.html { render action: "new" }
        format.json { render json: @discount_voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discount_vouchers/1
  # PUT /discount_vouchers/1.json
  def update
    @discount_voucher = DiscountVoucher.find(params[:id])

    respond_to do |format|
      if @discount_voucher.update_attributes(params[:discount_voucher])
        format.html { redirect_to discount_vouchers_path, notice: 'Discount voucher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discount_voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discount_vouchers/1
  # DELETE /discount_vouchers/1.json
  def destroy
    @discount_voucher = DiscountVoucher.find(params[:id])
    @discount_voucher.destroy

    respond_to do |format|
      format.html { redirect_to discount_vouchers_url }
      format.json { head :no_content }
    end
  end
end
