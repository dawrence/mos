class ClosingStage < ActiveRecord::Base
  attr_accessible :initial_cash, :physical_total, :system_expenses, :system_sales, :total_discount, :tips_total
  validates :physical_total, presence: true
  validates :initial_cash, presence: true
  paginates_per 10

  has_many :expenses

  def self.today_yet?
  	setting=Setting.getSetting()
  	cutoff_hour = setting ? setting.cutoff_date.hour : Time.now.hour
  	now = Time.now - cutoff_hour.hours
  	first_date = now.change(hour: cutoff_hour)
  	last_date = first_date + 1.day
  	cs = ClosingStage.where("created_at > :start AND created_at < :end", {start: first_date, end: last_date})
  	cs.empty?
  end



end
