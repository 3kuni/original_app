class UsersController < ApplicationController
  def show
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    @user=User.find(params[:id])
    @study_lst=Studysession.where(user:params[:id])
    @daily= Studysession.where(user:params[:id]).group("date(created_at)").sum(:time)
    @activities = PublicActivity::Activity.all
  end
  
  def index
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    @user=User.all.order("created_at desc")
    @activities = PublicActivity::Activity.all

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
