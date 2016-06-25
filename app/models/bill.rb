class Bill < ActiveRecord::Base  
  attr_accessible :price, :status, :table_id, :orders_attributes, :note, :previous_status, :people_quantity, :discount_voucher_id, :updated_mk, :user_id,:payment_type, :client_name, :client_address, :client_email, :tax ,:tip_type,:tip,:billing_number, :total, :discount_value, :created_at, :client_phone
  belongs_to :table
  has_many :orders, dependent: :destroy
  has_many :products, through: :orders
  belongs_to :discount_voucher
  belongs_to :user 

 # one bill can be QUEUE, PREPARED or PAID
  scope :active, where("bills.status NOT IN (?,?,?)", "paid", "canceled","pending")
  scope :queue, where(status: "queue")

  default_scope order: "bills.created_at ASC"

  accepts_nested_attributes_for :orders, allow_destroy: true

  def to_hash
    self.attributes.slice *Bill.accessible_attributes.to_a
  end

  def split(params=[])
    return if paid? || pending? || canceled? || !is_unlocked
    ActiveRecord::Base.transaction do
      b = Bill.new(to_hash.merge!("people_quantity" => 0))
      params.each do |d|
        order = Order.find(d)
        b.orders << order if order
      end
      b.save!
      b.check_prepared_orders
      b.calculate_price
      save!
      calculate_price
    end
  end

  def add_bill(bill)
    return if(bill.table_id != self.table_id or canceled? or paid? or not is_unlocked or pending?)
    bill.orders.each do |o|
      self.orders << o
    end
    self.status = "queue" if bill.queue?
    self.people_quantity = self.people_quantity.to_i + bill.people_quantity.to_i
    save!
    check_prepared_orders
    calculate_price
    bill.cancel("Anulacion por agrupacion de factura en #{self.id}")
  end

  def calculate_price
    c_price = orders.sum{|d| d.quantity*d.unit_price + (d.product.additionals.sum{|d| d.quantity * d.unit_price} if d.product).to_i}
    update_attributes!(price: c_price) if c_price
  end

  def canceled?
    self.status == "canceled"
  end

  def queue?
    self.status == "queue"
  end

  def paid?
    self.status == "paid"
  end

  def pending?
    self.status == "pending"
  end

  def check_prepared_orders
    update_attributes(status: 'prepared') if orders.prepared.size == orders.valid.size
  end
  
  def self.get_orders(scope)
    return orders if scope == "all"
    orders.where(status: scope)
  end

  def has_orders?(kitchen)
    orders.queue.each do |o|
      return true if o.product && o.product.has_kitchen?(kitchen)
    end
    false
  end

  def prepare_by_kitchen(kitchen_id=nil,user_id=nil,log="")
    if is_unlocked
      ActiveRecord::Base.transaction do
        orders.each do |o|
          o.prepare(kitchen_id,user_id,log)
        end
      end
      check_prepared_orders
    end
  rescue ActiveRecord::RecordInvalid => exception
    raise exception
  end

  def self.get_by_kitchen(kitchen_id)
    queue.joins(products: :product_kitchens).where("kitchen_id = ?",kitchen_id).group("bills.id, bills.status")
  end

  def self.viewable
  	find(:all, conditions: ["bills.status = 'queue' OR bills.status = 'preparation'"])  	
  end

  def in_queue?(kitchen)
    get_orders("queue")
  end

  def validate_bill(id=0)
    errors.clear    
    products_quantities = {}
    valid = true
    orders.each do |o|
      if o        
        if o.product          
          products_quantities["p_#{o.product.menu_product_id}".to_sym] = o.quantity.to_i+( (not products_quantities["p_#{o.product.menu_product_id}".to_sym])? 0 : products_quantities["p_#{o.product.menu_product_id}".to_sym]).to_i
          if not o.product.check_availability(products_quantities["p_#{o.product.menu_product_id}".to_sym],id)
            errors.add(:base,"Producto #{o.product.menu_product.name} no esta disponible. ")   
            valid= false         
          end
          o.product.additionals.each do |a|
            if a.additional 
              products_quantities["p_#{a.additional.menu_product_id}".to_sym] = a.quantity.to_i+((not products_quantities["p_#{a.additional.menu_product_id}".to_sym]) ? 0 : products_quantities["p_#{a.additional.menu_product_id}".to_sym]).to_i
              if not a.additional.check_availability(products_quantities["p_#{a.additional.menu_product_id}".to_sym] ,id)
                errors.add(:base,"Adicional #{a.additional.menu_product.name} no esta disponible. ")  
                valid = false 
              end            
            end
          end
        end        
      end
    end
    return valid 
  end

  def self.get_pending 
    bills_pending=Bill.includes([ :orders,
                    {
                      products: 
                        [
                          :ingredients,
                          :supplies,
                          {
                            additionals: 
                            [{additional: :menu_product}]
                          },
                          { menu_product: :product}
                        ]
                    },
                    :table,
                    :discount_voucher
                    ]).where(status: "pending").reorder("bills.billing_number ASC")
    return bills_pending
    
  end

  def self.get_current_paid
    current_time = Time.now
    setting=Setting.getSetting() 
    cutoff_hour = setting ? setting.cutoff_date.hour : Time.now.hour
    now = Time.now - cutoff_hour.hours
    first_date = now.change(hour: cutoff_hour)
    last_date = now.change(hour: cutoff_hour) + 1.day    
    bills_paid=Bill.includes([ :orders,
                    {
                      products: 
                        [
                          :ingredients,
                          :supplies,
                          {
                            additionals: 
                            [{additional: :menu_product}]
                          },
                          { menu_product: :product}
                        ]
                    },
                    :table,
                    :discount_voucher
                    ]).where(updated_at: first_date..last_date, status: "paid").reorder("bills.billing_number ASC")
    return bills_paid
    
  end

  def formated_order_elapsed_time
    elapsed_time = Time.now - self.created_at
    [elapsed_time/3600, elapsed_time/60%60, ((elapsed_time/60)/60)%60].map{|t| t.to_i.to_s.rjust(2, '0')}.join(':')
  end

  def elapsed_time
    elapsed_time = Time.now - self.created_at
  end

  def is_unlocked
    return !self.updated_mk
  end
  
  def cancel (note)
    self.previous_status = self.status
    self.status = "canceled"
    self.note = note
    self.save
  end

  def getDiscountValue
    if self.discount_voucher
      return self.discount_value == 0 ? (self.discount_voucher.discount_type.to_sym == :per ? (self.price * (self.discount_voucher.value/100)) : self.discount_voucher.value) : self.discount_value
    else
      return 0
    end
  end

  def pending
    if self.status == "prepared"
      self.status="pending"
      self.save
    else
      throw Exception("unavailable operation")
    end
  end

  def getTotal
    discount = self.discount_value == 0 ? self.getDiscountValue : self.discount_value
    return self.total == 0 ? (self.price - discount+ self.tip).to_f : self.total
  end

end
