class MenuProduct < ActiveRecord::Base
  attr_accessible :description, :name, :product_family_id, :products_attributes, :modificable, :additional
  belongs_to :product_family
  has_many   :products,dependent: :destroy
  has_one    :product, :conditions => ['products.original = ?', true]
  validates :name, :presence => true

  default_scope order: 'menu_products.name ASC'
  
  accepts_nested_attributes_for :products, allow_destroy: true

  def update_with(product,menu_product_params)
    menu_product_params.delete(:products_attributes)
    puts menu_product_params
    update_attributes!(menu_product_params)
    product.menu_product_id = self.id
  	product.make_original()    
  	self.product.make_original_copy()
    true
  end

end
