class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
 
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
	@user = User.new
  end
  
  def show
    @user = User.find(params[:id])
	@user_age = calculate_user_age(@user.birthdate)
	@user_gender = calculate_user_gender(@user.gender)
	@rides = @user.rides
	@microposts = @user.microposts.paginate(:per_page => 4, page: params[:page])
    @micropost = current_user.microposts.build if signed_in?
	@user_stats = calculate_stats(@user)
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
	  @user.microposts.create(:content => @user.name + " joined tracknwin community!")
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  def androidlogin
	if request.post?
	username = params[:username]
	password = params[:password]
		if User.find_by_email(username) != nil
			user = User.find_by_email(username)
				if user.authenticate(password)
					response = ""+user.name+"&"+user.email+"&"+user.remember_token+""

					#response[0] = user.name
					#response[1] = user.remember_token
					jsonresponse = response.to_json
					#jsonresponse = 
					render :inline => jsonresponse
				else
					render :inline => "false"
				end
		else
			render :inline => "false"
		end
	else
	redirect_to signin_url, notice: "There is no place for you ;)"
	end
	#render :nothing => true, :status => 500

	end	
	
	def androidregister
	if request.post?
	@user = User.new(params[:user])
    if @user.save
			render :inline => "true"
    else
	errors = "Errors: "
	@user.errors.full_messages.each do |msg| 
		errors = errors + msg + ", "
	end
      
      		render :inline => errors
    end

	else
	redirect_to signin_url, notice: "There is no place for you ;)"
	end

	end	
  
   def search
	q = "%#{params[:search]}%"
	@results = User.where("name like ? or email like ?", q, q)
	@users = @results.paginate(page: params[:page])
   end
   
   	def calculate_user_age(bd)
	d = Time.now
    a = d.year - bd.year
    a = a - 1 if (
         bd.month >  d.month or 
        (bd.month >= d.month and bd.day > d.day)
    )
    a
	end
	
	def calculate_user_gender(g)
	if g == "M" 
	gender = "male"
	else
	gender = "female"
	end
	end
	
	def calculate_stats(user)
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
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
	
	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
	
	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
	



end
