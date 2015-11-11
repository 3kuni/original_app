class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      @feeditems=current_user.feed
      @activities = PublicActivity::Activity.order(created_at: :desc).all
    end
  end
end
