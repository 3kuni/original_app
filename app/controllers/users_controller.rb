class UsersController < ApplicationController
  def show
    @user=User.find(params[:id])
    @study_lst=Studysession.where(user:params[:id])
  end
  
  def index
    @user=User.all
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    #@users = @user.followed_users.paginate(page: params[:page])
    @users = @user.followed_users
    
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    #@users = @user.followers.paginate(page: params[:page])
    @users = @user.followers
    
    render 'show_follow'
  end  
end
