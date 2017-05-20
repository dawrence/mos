class InventoryMovement < ActiveRecord::Base
  attr_accessible :description, :movement_type, :quantity, :supply_id, :adjustment, :user_id
  paginates_per 10
  belongs_to :supply
  belongs_to :user
  
  def self.list
  	select("created_at,description,movement_type,quantity as cnt").group(:created_at,:description,:movement_type,:quantity)
  end
  
  def self.to_csv
    attributes = %w"created_at description movement_type cnt "
    CSV.generate do |csv|
      csv << attributes
      all.each do |result|
        csv << result.attributes.values_at(*%w"created_at description movement_type cnt")
      end
    end
  end
end
