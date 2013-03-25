class Ride < ActiveRecord::Base
  attr_accessible :body
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true
  
  default_scope order: 'rides.created_at DESC'
end
