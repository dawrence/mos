class Supply < ActiveRecord::Base
  attr_accessible :name, :supply_category_id, :availability
  has_many   :ingredients, dependent: :destroy
  belongs_to :supply_category
  has_one :inventory 
  has_many :products, through: :ingredients
  has_many :inventory_movements
  validates :name, :presence => true, :uniqueness => true
  validates :supply_category_id, :presence => true

  def update_availability(movement_type, quantity)
  	if movement_type == "in"
  		self.availability += quantity
  		self.save
  	else
  		self.availability -= quantity
  		self.save
  	end  	
  end

  def self.get_additionals_supplies(status,init_date,end_date,bill_except_id=0)
    Supply.select("supplies.id as supply_id, supplies.name as supply_name, SUM(ingredients.quantity * additionals.quantity) as available_quantity")
          .from("products, additionals,bills,orders,supplies,ingredients")
          .where("    additionals.product_id = orders.product_id
                  AND additionals.additional_id = products.id 
                  AND bills.status IN (?) 
                  AND bills.updated_at BETWEEN ? AND ?
                  AND bills.id = orders.bill_id
                  AND bills.id != ?
                  AND ingredients.product_id = products.id
                  AND ingredients.supply_id  = supplies.id", status, init_date, end_date, bill_except_id)
          .group("supplies.id, supplies.name")
  end
  def self.get_supplies_sumarize(status,init_date,end_date,supply_id=nil,bill_except_id=0)
    Supply.select("a.supply_id, a.supply_name, SUM(available_quantity) as available_quantity")
          .from( "( #{Supply.get_additionals_supplies(status,init_date,end_date,bill_except_id).to_sql} UNION ALL  
                    #{Supply.get_products_supplies(status,init_date,end_date,bill_except_id).to_sql} ) a")
          .where(supply_id ? "a.supply_id = ?" : "true", supply_id)
          .group("a.supply_id, a.supply_name")
  end

  def self.get_products_supplies(status,init_date,end_date,bill_except_id=0)
    Supply.joins(products: :bills)
          .select("supplies.id as supply_id, supplies.name as supply_name, SUM(ingredients.quantity * orders.quantity) as available_quantity")
          .where("bills.status IN (?) AND bills.updated_at BETWEEN ? AND ? AND bills.id != ?",status,init_date,end_date,bill_except_id)
          .group("supplies.id, supplies.name")
  end

end
