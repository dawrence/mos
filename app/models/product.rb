class Product < ActiveRecord::Base
  attr_accessible :menu_product_id, :original, :original_copy, :price,  :ingredients_attributes, :additionals_attributes, :product_kitchens_attributes
  
  has_many   :ingredients, dependent: :destroy
  has_many   :quantifiable_ingredients, class_name: 'Ingredient', conditions: ['ingredients.quantifiable = ?', true]
  has_many   :orders
  belongs_to :menu_product
  has_many   :supplies, through: :ingredients
  has_many   :bills, through: :orders
  has_many   :additionals, dependent: :destroy

  has_many   :product_kitchens

  has_many   :kitchens, through: :product_kitchens

  validates :price, :presence => true

  after_save :save_kitchens

  def has_kitchen?(kitchen)
    kitchens.map(&:id).include?(kitchen.is_a?(Kitchen) ? kitchen.id : kitchen.to_i)
  end

  def save_kitchens
    if kitchens.empty? && menu_product
      menu_product.product.kitchens.each do |k|
        kitchens << k
      end
      Product.skip_callback(:save,:after,:save_kitchens)
      save!
      Product.set_callback(:save,:after,:save_kitchens)
    end
  end

  def get_today_default_range
    current_time = Time.now.in_time_zone("America/Bogota")
      setting=Setting.getSetting()
      cutoff_hour = setting.cutoff_date.hour
      now = Time.now - cutoff_hour.hours
      first_date = now.change(hour: cutoff_hour)
      last_date = now.change(hour: cutoff_hour) + 1.day  
      return {init_date: first_date, end_date: last_date}
  end

  def equal_with(product)
    if product
      return false if product.ingredients.length != self.ingredients.length
      product.ingredients.each do |i|
        return false if not contains_ingredient(i)
      end
      return product.menu_product_id == self.menu_product_id && self.price == product.price
    end 
    return false
  end

  def check_availability(quantity=1,except=0)    
    if INVENTORY
        self.ingredients.where(quantifiable:true).each do |i|
          inv_supply = Inventory.find_by_supply_id(i.supply_id) != nil ?
                       Inventory.find_by_supply_id(i.supply_id).supply_availability : 0
          supply = Supply.get_supplies_sumarize(["queue"],get_today_default_range[:init_date],get_today_default_range[:end_date],i.supply_id,except)
          que_supply =  if supply && !supply.empty?
                          supply.first.available_quantity.to_i
                        else
                          0
                        end                     
          if (inv_supply - (que_supply + (i.quantity.to_i*quantity))) < 0
            return false    
          end      
        end
        return true
    else
      true
    end
  end

  def make_original
    self.original = true
    self.original_copy = false
    self.save
  end

  def make_original_copy
    self.original = false
    self.original_copy = true
    self.save
  end

  def self.original
  	find_by_original(true)  	
  end

 def get_original_product
   Product.includes(:ingredients,:supplies).where(menu_product_id: self.menu_product_id, original: true).first
 end

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :product_kitchens, allow_destroy: true
  accepts_nested_attributes_for :additionals, allow_destroy: true

  private
  def contains_ingredient(ingredient)
    self.ingredients.each do |i|
      return true if ingredient.supply_id == i.supply_id && ingredient.quantity == i.quantity
    end    
    false
  end
end

