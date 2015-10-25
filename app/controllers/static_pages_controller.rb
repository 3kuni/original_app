class StaticPagesController < ApplicationController
  def home
    unless request.url == "http://www.stardy.co/"
      redirect_to "http://www.stardy.co/"
    end
    if signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      @feed_items=current_user.feed
    end
  end
end
