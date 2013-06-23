class FriendshipsController < ApplicationController
  
  def index
    @pending_requests = current_user.pending_invited_by
	@pending_invites = current_user.pending_invited
    @friends = current_user.friends

  end

  def new
    @users = User.all :conditions => ["id != ?", current_user.id]

  end

  def create
    invitee = User.find_by_id(params[:user_id])
    if current_user.invite invitee
	  flash[:success] = "Successfully invited friend!"
      redirect_to friends_path
    else
	  flash[:error] = "Sorry! You can't invite that user!"
      redirect_to friends_path
    end
  end

  def update
    inviter = User.find_by_id(params[:id])
    if current_user.approve inviter
	  current_user.microposts.create(:content => current_user.name + " became a friend with " + inviter.name + ".")
	  inviter.microposts.create(:content => inviter.name + " became a friend with " + current_user.name + ".")
	  flash[:success] = "Successfully confirmed friend!"
      redirect_to friends_path
    else
	  flash[:error] = "Sorry! Could not confirm friend!"
      redirect_to friends_path
    end
  end
  

  def destroy
    user = User.find_by_id(params[:id])
    if current_user.remove_friendship user
	  flash[:success] = "Successfully removed friend!"
      redirect_to friends_path
    else
	  flash[:error] = "Sorry, couldn't remove friend!"
      redirect_to friends_path
    end
  end 
  
end