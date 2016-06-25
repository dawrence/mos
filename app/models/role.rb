class Role < ActiveRecord::Base
  attr_accessible :name, :description, :identifier, :role_type
  scope :modules, where(role_type: "module")
  scope :reports, where(role_type: "report")
  scope :actions, where(role_type: "action")
  has_many :privileges
  has_many :users, through: :privileges
end
