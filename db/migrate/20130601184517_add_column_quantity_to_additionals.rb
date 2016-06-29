class AddColumnQuantityToAdditionals < ActiveRecord::Migration
  def change
  	add_column :additionals, :quantity, :integer , default:0
  end
end
