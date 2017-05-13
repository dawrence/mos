class PaidProduct < ActiveRecord::Base
  attr_accessible  :unit_price, :product_price, :product_id, :product_name, :size


  def self.retrieve(init_date, end_date)
    setting=Setting.getSetting()
    cutoff_hour = setting.cutoff_date.hour
    init_date = DateTime.strptime(init_date, "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
    end_date = DateTime.strptime(end_date, "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0)
  	select("product_name, product_id, unit_price, product_price, SUM(size) as cnt")
  	.where(order_date: init_date..end_date)
  	.group(:product_id,:product_name,:unit_price,:product_price)
  end
  
  def self.list
  	select("product_name, product_id, unit_price, product_price, SUM(size) as cnt")
  	.group(:product_id,:product_name,:unit_price,:product_price)
  end
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*%w"product_name unit_price product_price cnt")
      end
    end
  end
	
end
