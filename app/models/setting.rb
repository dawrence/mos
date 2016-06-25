class Setting < ActiveRecord::Base
  attr_accessible :address, :billing_resolution, :billing_system_resolution, :business_name, :city, :consumption_tax, :date, :lower_range, :mail, :nit, :prefix, :telephone, :tip_text, :upper_range, :cutoff_date

  def self.getSetting
  	self.first
  end

end
