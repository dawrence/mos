class InventoryMovement < ActiveRecord::Base
  attr_accessible :description, :movement_type, :quantity, :supply_id, :adjustment, :user_id
  paginates_per 10
  belongs_to :supply
  belongs_to :user
  
  def self.list
  	select("description,movement_type,quantity as cnt")
  	.group(:description,:movement_type,:quantity)
  end
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*%w"description movement_type quantity cnt")
      end
    end
  end
end
