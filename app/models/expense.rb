class Expense < ActiveRecord::Base
  attr_accessible :description, :receipt_number, :value

  belongs_to :user

  before_save :parameterize_value

  scope :uncounted, where(counted: false)


  def self.mark_as_counted
  	all.each do |e|
  		e.mark_as_counted
  	end
  end

  def mark_as_counted
  	self.counted = true
  	self.save
  end

  protected 

  def parameterize_value
    self.value = self.value.to_f
  end
end
