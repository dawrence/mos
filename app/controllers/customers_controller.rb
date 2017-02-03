class CustomersController < ApplicationController

  respond_to :json

  def show
    customer = Customer.find_by(national_id: params[:client_id])
    render json: customer, status: 200
  end

  def create
    Customer.create(params[:customer])
    render json: {}, status: 200
  end

  def index
    render json: Customer.all
    render json: customer, status: 200
  end
end
