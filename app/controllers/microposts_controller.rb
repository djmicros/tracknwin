class MicropostsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.create(:content => params[:content])
    if @micropost.save
      flash[:success] = "Post added!"
      redirect_to current_user
    else
      flash[:danger] = "Post is too long!"
      redirect_to current_user
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by_id(params[:id])
    @micropost.destroy
      flash[:success] = "Post deleted!"
      redirect_to current_user
  end
  
end