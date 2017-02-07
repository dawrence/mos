class PaymentsController < ApplicationController
	def privileges
		[{generic: [:bills_payment]}]
	end
	def new
	  @bill = Bill.find(params[:id])
	  # validates for lock
	  if @bill.is_unlocked
	    @discounts = DiscountVoucher.where(by_ocurrence: false)
	    @vld = true
	  else
	    @notice = t(:being_updated)
	    @vld = false
	  end
	  respond_to do |format|
	    format.js
	  end
	end

	def pay_all
	  @bill = Bill.find(params[:id])
	  if @bill.is_unlocked && [:prepared,:pending].include?(@bill.status.to_sym)
	    setting = Setting.getSetting()
	    if setting
	      if params[:discount].to_i != -1
	      	discount_voucher = DiscountVoucher.find(params[:discount])
	        @bill.discount_voucher = discount_voucher
	      end
	      @bill.status = 'paid'

	      @bill.tip = params[:tip_type].to_sym == :val ? params[:tip].to_f : ((params[:tip].to_f/100)*@bill.price.to_f)
	      @bill.tip_type = params[:tip_type]
	      @bill.tax = (setting.consumption_tax.to_f* @bill.price.to_f)/(100 + setting.consumption_tax.to_f )

	      if discount_voucher && discount_voucher.discount_type.to_sym == :per
	        @bill.discount_value = @bill.price * (discount_voucher.value/100)
	      elsif discount_voucher && discount_voucher.discount_type.to_sym == :var
	      	@bill.discount_value = params[:discount_value].to_i
	      else
	        @bill.discount_value = discount_voucher && discount_voucher.value ? discount_voucher.value : 0
	      end

	      @bill.total = (@bill.price - @bill.discount_value + @bill.tip).to_f
	      @bill.client_name = params[:client_name]
	      @bill.client_address = params[:client_address]
	      @bill.client_phone = params[:client_phone]
	      @bill.client_email = params[:client_email]
	      @bill.payment_type = params[:payment_type]

        if params[:add_client] == 'add_client'
          create_client({
            national_id: params[:client_id],
            tel: params[:client_phone],
            email: params[:client_email],
            name: params[:client_name],
            address: params[:client_address]
          })
        end

	      max_number = Bill.maximum(:billing_number)
	      if @bill.payment_type.to_sym == :cash || @bill.payment_type.to_sym == :card

	        if max_number + 1 >= setting.lower_range.to_i && max_number + 1 <= setting.upper_range.to_i
	          max_number += 1  if B_INCREMENT
	          @bill.billing_number = max_number
	          if @bill.save
	            @vld = true
	            @notice = t(:bill_payed)
	          else
	            @vld = false
	            @notice = t(:forget_to_refresh)
	          end
	        else
	          @vld = false
	          @notice = "No se puede pagar ni facturar. El limite de facturacion ha sido alcanzado, por favor comuniquese con el representante legal."
	        end
	      else
	        @bill.billing_number = max_number
	        if @bill.save
	            @vld = true
	            @notice = t(:bill_payed)
	          else
	            @vld = false
	            @notice = t(:forget_to_refresh)
	        end
	      end
	    else
	      @vld =false
	      @notice = "No se puede pagar ni facturar. No se ha configurado la informacion de facturacion del local. Comuniquese con el Representante legal"
	    end
	  else
	    @vld = false
	    @notice = t(:forget_to_refresh)
	  end
	rescue => e
	  @vld = false
	  @notice = t(:forget_to_refresh)
	ensure
	  respond_to do |format|
	    format.js
	  end
	end


  private

  def create_client(data={})
    customer = Customer.new(data)
    if customer.valid?
      puts 'customer valid'
      customer.save
    else
      puts 'cuystomer invalid'
      c = Customer.where(national_id: data[:national_id]).first
      c.ocurrences = (c.ocurrences ? c.ocurrences : 1) + 1
      c.save
    end
  end
end
