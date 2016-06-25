class Table < ActiveRecord::Base
  attr_accessible :description, :name, :auxiliar
  has_many :bills
  has_many :active_bills, class_name: 'Bill', conditions: ['bills.status NOT IN(?,?,?)','paid', 'canceled','pending']


  scope :aux, where(auxiliar: true)
  scope :normal, where(auxiliar: false)
  default_scope order: 'tables.name'
  
end
