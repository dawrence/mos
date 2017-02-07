class Expense < ActiveRecord::Base
  attr_accessible :description, :receipt_number, :value
  paginates_per 15
  belongs_to :user

  before_save :parameterize_value

  scope :uncounted, where(counted: false)

  belongs_to :closing_stage


  def self.mark_as_counted
  	all.each do |e|
  		e.mark_as_counted
  	end
  end

  def mark_as_counted(closing_stage_id)
  	self.counted = true
    self.closing_stage_id = closing_stage_id
  	self.save
  end

  protected

  def parameterize_value
    self.value = self.value.to_f
  end
end
