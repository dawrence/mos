class AddZDateToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :cutoff_date, :datetime, default: Time.now
  end
end
