class RidesController < ApplicationController
	
	def index
    @user = User.find(params[:user_id])
	@rides = @user.rides
	end
	
	def show
    @ride = Ride.find(params[:id])
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
end
