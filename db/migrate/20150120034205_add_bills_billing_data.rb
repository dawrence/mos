class AddBillsBillingData < ActiveRecord::Migration
  def change
  	add_column :bills, :payment_type, :string, default: :cash
  	add_column :bills, :billing_number, :integer, default: 0
  	add_column :bills, :client_name, :string
  	add_column :bills, :client_address, :string
  	add_column :bills, :client_phone, :string
  	add_column :bills, :client_email, :string
  	add_column :bills, :tax, :float,  default: 0
  	add_column :bills, :tip_type, :string,  default: "val"
  	add_column :bills, :tip, :float,  default: 0
  end
end
