class User < ActiveRecord::Base
  include Amistad::FriendModel
  
  has_many :rides, dependent: :destroy
  
  has_many :microposts, dependent: :destroy
	
  attr_accessible :name, :email, :password, :password_confirmation, :gender, :birthdate, :team, :country
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates_confirmation_of :password
  validates :gender, presence: true
  VALID_BIRTHDATE_REGEX = /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
  validates :birthdate, presence: true, 
					format:     { with: VALID_BIRTHDATE_REGEX }
  validates :country, presence: true
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
	
		def self.calculate_stats(user)
	rides = user.rides
	if rides.count == 0
	@stats = []
	@stats[0] = 0
	@stats[1] = 0
	@stats[2] = 0
	else
	@distance_sum = 0
	@duration_sum = 0
	@speed_sum = 0
	(0..rides.count-1).each do |i|
	@distance_sum = @distance_sum + rides[i].distance.to_f
	@duration_sum = @duration_sum + rides[i].duration.to_f
	@speed_sum = @speed_sum + rides[i].speed.to_f
	end
	@avg_speed = @speed_sum/rides.count
	@stats = []
	@stats[0] = @distance_sum.round(2)
	@stats[1] = @duration_sum
	@stats[2] = @avg_speed.round(2)
	return @stats
	end
	end
end