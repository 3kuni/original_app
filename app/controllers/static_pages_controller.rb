class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      @feed_items=current_user.feed
    end
  end
end
