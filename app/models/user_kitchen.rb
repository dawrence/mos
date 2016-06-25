class UserKitchen < ActiveRecord::Base
  attr_accessible :kitchen_id, :user_id
  belongs_to :user
  belongs_to :kitchen
end
