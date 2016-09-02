class StaticPagesController < ApplicationController
  def home
    @feeditems = Studysession.all.limit(30)
    if user_signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      #@feeditems=current_user.feed
      @activities = PublicActivity::Activity.order(created_at: :desc).all
    end
  end

  def api
  	@personal = {'name' => 'Yamada', 'old' => 28}

  	respond_to do |format|
	    format.html
	    format.json {render :json => @personal}
		end
  end
end
