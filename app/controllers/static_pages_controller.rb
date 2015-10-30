class StaticPagesController < ApplicationController
  def home
    if request.url == "http://stardy-3kuni.sqale.jp/"
      redirect_to "http://www.stardy.co/"
    end
    if signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      @feed_items=current_user.feed
      @activities = PublicActivity::Activity.order(created_at: :desc).all
    end
  end
end
