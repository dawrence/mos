class Order < ActiveRecord::Base
  attr_accessible :bill_id, :product_id, :ship, :quantity, :unit_price, :product_attributes, :status
  
  after_destroy :delete_custom_products

  belongs_to :product
  belongs_to :bill

  scope :prepared, where(status: "prepared")
  scope :queue, where(status: "queue")
  scope :paid, where(status: "paid")
  scope :pending, where(status: "pending")
  scope :valid, where("product_id is not null")

  accepts_nested_attributes_for :product, allow_destroy: true

  def prepare(kitchen_id=nil,user_id=nil,log_user="")
  	if queue? && product && ( kitchen_id ? product.has_kitchen?(kitchen_id) : true )
      update_attributes(status: "prepared")
      prepare_product(product,user_id,log_user)
    end
  end

  def queue?
	  status == 'queue'  	
  end

  def prepared?
  	status == 'prepared'
  end

  def paid
  	update_attributes!(status: "paid") if prepared?
  end

  def pending
  	update_attributes!(status: "pending") if prepared?
  end

  private

  def prepare_product(p,user_id=nil,log_user="")
    if INVENTORY
    	p.ingredients.where(quantifiable:true).each do |i|
        InventoryMovement.create(description: "Salida por pedido bill:#{bill_id} producto:#{product_id} #{log_user} Insumo normal", movement_type: "out", quantity: (i.quantity * quantity), supply_id: i.supply_id,user_id: user_id)
      end

      if p.additionals
        p.additionals.each do |ad|
          if ad.additional                     
             ad.additional.ingredients.where(quantifiable:true).each do |i|
              InventoryMovement.create(description: "Salida por pedido bill:#{bill_id} producto:#{ad.additional.id}. #{log_user} Adicional", movement_type: "out", quantity: (i.quantity * ad.quantity), supply_id: i.supply_id,user_id:user_id)
             end
          end
        end
      end
    end
  end


  def delete_custom_products
  	self.product.destroy if self.product && !(self.product.original || self.product.original_copy)
  end
end
