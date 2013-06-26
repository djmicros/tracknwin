class Ride < ActiveRecord::Base
  attr_accessible :body, :user_id, :distance, :duration, :speed
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
  
  default_scope order: 'rides.created_at DESC'
   
end
