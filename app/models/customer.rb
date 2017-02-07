class Customer < ActiveRecord::Base
  attr_accessible :national_id, :email, :name, :last_name, :confirmed, :ocurrences, :tel, :address

  validates :national_id, presence: true, uniqueness: true

  before_save :set_ocurrence

  paginates_per 15

  def set_ocurrence
    self.ocurrences = self.ocurrences ? self.ocurrences : 1
  end

end
