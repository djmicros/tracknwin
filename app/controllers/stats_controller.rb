class StatsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :create]
  
  def index
  @stats = Stats.new
  @params = 0
  @users = User.all
  
  if @params == 0
  @users_with_stats = []
  @all_stats = []
  	for i in 0..@users.count-1
		user_id = @users[i].id
		user_stats = User.calculate_stats(User.find(user_id))
		@all_stats.push(user_stats)
		distance = user_stats[0]
		duration = user_stats[1]
		speed = user_stats[2]
		@users[i] = @users[i].attributes.merge!(:distance => distance, :duration => duration, :speed => speed)
		@users_with_stats.push(@users[i])
	end
	#@users = @users_with_stats
	if @params == 0
	@users = @users_with_stats.sort_by { |k| -k[:distance] }
	end

  
  end
  
  end
  
  def create
  @stats = Stats.new
  @params = params[:stats]
  @users = User.all

  if @params[:country] != ""
  @users = User.where(:country => @params[:country])
  end

  if @params[:male] == "true" && @params[:female] == "0"
  @male_users = User.where(:gender => "M")
  @users = @users & @male_users
  end
  
  if @params[:female] == "true" && @params[:male] == "0"
  @female_users = User.where(:gender => "F")
  @users = @users & @female_users 
  end
  
  if @params[:team] != ""
  @team_users = User.where(:team => @params[:team])
  @users = @users & @team_users 
  end
  
  if @params[:age1] != "" && @params[:age2] != ""
  @all_users = User.all
  @age_users = []
	for i in 0..@all_users.count-1
	current_user_age = Date.today.year - @all_users[i].birthdate.to_date.year
	if current_user_age >= @params[:age1].to_i && current_user_age <= @params[:age2].to_i
	@age_users.push(@all_users[i])
	end
  end
  @users = @users & @age_users
  end
  
  
  if @params[:sort] == "" || @params[:sort] == "Distance" || @params[:sort] == "Duration" || @params[:sort] == "Speed"
  @users_with_stats = []
  @all_stats = []
  	for i in 0..@users.count-1
		user_id = @users[i].id
		user_stats = User.calculate_stats(User.find(user_id))
		@all_stats.push(user_stats)
		distance = user_stats[0]
		duration = user_stats[1]
		speed = user_stats[2]
		@users[i] = @users[i].attributes.merge!(:distance => distance, :duration => duration, :speed => speed)
		@users_with_stats.push(@users[i])
	end
	#@users = @users_with_stats
	if @params[:sort] == "" || @params[:sort] == "Distance"
	@users = @users_with_stats.sort_by { |k| -k[:distance] }
	end
	
	if @params[:sort] == "Duration"
	@users = @users_with_stats.sort_by { |k| -k[:duration] }
	end
	
	if @params[:sort] == "Speed"
	@users = @users_with_stats.sort_by { |k| -k[:speed] }
	end

  
  end

  end
  
  
  def difference_between_arrays(array1, array2)
  difference = array1.dup
  array2.each do |element|
    if index = difference.index(element)
      difference.delete_at(index)
    end
  end
  difference
end

end
