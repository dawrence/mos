class CustomersController < ApplicationController
  include ApplicationHelper
  include DiscountVouchersHelper
  respond_to :json

  def show
    @customer = Customer.where(national_id: params[:client_id]).first
    discounts = DiscountVoucher.where(by_ocurrence: true).map do |s|
      s if @customer.ocurrences % s.ocurrences == 0
    end
    if @customer
      render json: {
        customer: @customer,
        discounts: view_context.render_discounts(discounts)
        }, status: 200
    else
      render json: {}, status: 404
    end
  end

  def create
    Customer.create(params[:customer])
    render json: {}, status: 200
  end

  def index
    @customers = Customer.page(params[:page]).per(15)
    respond_to do |format|
      format.html
    end
  end
end
