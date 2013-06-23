class RidesController < ApplicationController
	
	def index
    @user = User.find(params[:user_id])
	@rides = @user.rides
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
	end
	
	def show
    @ride = Ride.find(params[:id])
	@ride_elements = getrideelements(@ride.body.to_s)
	@ride_distance = calc_distance(@ride_elements)
	@ride_time = calc_time(@ride_elements)
	@ride_speed = calc_speed(@ride_time, @ride_distance)
	render :layout => "ride"
	end
	
	def androidaddride
	if request.post?
	username = params[:username]
	password = params[:password]
	body = params[:body]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
				if user.authenticate(password)
					newride = Ride.new("body" => body, "user_id" => user.id)
					if newride.save
					ride_elements = getrideelements(newride.body)
					ride_distance = calc_distance(ride_elements)
					ride_time = calc_time(ride_elements)
					user.microposts.create(:content => user.name + " finished " + ride_distance.to_s + " km ride in " + ride_time[2].to_s + " .")
					render :inline => "true"
					else
					render :inline => "false"
					end
				else
					render :inline => "false"
				end
		else
			render :inline => "false"
		end
	else
	redirect_to signin_url, notice: "There is no place for you ;)"
	end
	end
	
	def getrideelements(body)
	ride = body.split('|')
	ride.first.gsub!('[','').gsub!(']','')
	ride.last.gsub!('[','').gsub!(']','')
	return ride
	end
	
	def calc_distance(origin)

	@distance = 0
	i = 1
		while i < origin.count-2  do
	radius = 6371
	lat1 = to_rad(origin[i].split(',')[0].to_f)
	lat2 = to_rad(origin[i+1].split(',')[0].to_f)
	lon1 = to_rad(origin[i].split(',')[1].to_f)
	lon2 = to_rad(origin[i+1].split(',')[1].to_f)
	dLat = lat2-lat1   
	dLon = lon2-lon1

	a = Math::sin(dLat/2) * Math::sin(dLat/2) +
		Math::cos(lat1) * Math::cos(lat2) * 
		Math::sin(dLon/2) * Math::sin(dLon/2);
	c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a));
	d = radius * c	

	@distance = @distance + d
	i += 1
	end
	return @distance.round(3)
	end
	
	def to_rad angle
	angle * Math::PI / 180 
	end
	
	def calc_time(elements)
	rstart = "2001-01-01 "+elements.first
	rend = "2001-01-01 "+elements.last
	hours = (((rstart.to_time - rend.to_time) / 1.minute).round*(-1).to_f/60).round(0)
	minutes = ((rstart.to_time - rend.to_time) / 1.minute).round*(-1) % 60
	ride_time = []
	ride_time[0] = ((rstart.to_time - rend.to_time) / 1.minute).round*(-1)
	ride_time[1] = (((rstart.to_time - rend.to_time) / 1.minute).round*(-1).to_f/60).round(1)
	ride_time[2] = hours.to_s + " hours " + minutes.to_s + " minutes"
	return ride_time
	end
	
	def calc_speed(ride_time, distance)
	time=ride_time[0]
	speed = (60*distance.to_f)/time.to_f
	speed.round(2)
	end
end
