class Customer < ActiveRecord::Base
  attr_accessible :national_id, :email, :name, :last_name, :confirmed, :ocurrences, :tel, :address

  validates :national_id, presence: true, uniqueness: true

  before_save :set_ocurrence

  def set_ocurrence
    c = Customer.find_by(national_id: self.national_id)
    c.update_attributes(ocurrences: c.ocurrences + 1) if c
  end


end
