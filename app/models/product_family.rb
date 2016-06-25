class ProductFamily < ActiveRecord::Base
  attr_accessible :description, :name, :image, :additional_family, :order
  scope :additionals, where(:additional_family => true); 
  has_many :menu_products, dependent: :destroy
  has_many :products , through: :menu_products
  default_scope order: 'product_families.order'


end
