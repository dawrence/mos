class Kitchen < ActiveRecord::Base
  attr_accessible :description, :name, :short_name
  has_many :product_kitchens, dependent: :destroy
  has_many :user_kitchens, dependent: :destroy
  has_many :users, through: :user_kitchens
  has_many :products, through: :product_kitchens
end
