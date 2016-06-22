class StaticPagesController < ApplicationController
  def home
    @feeditems = Studysession.all.limit(20)
    @studysession=Studysession.new
    @task = Studysession.where(user:current_user.id,task:"todo")
    @history = Studysession.where(user:current_user.id).uniq.limit(5).pluck(:textbook)
    if user_signed_in?
      @active_now=Studysession.find_by(user:current_user.id,active:true)
      @user=User.find(current_user.id)
      #@feeditems=current_user.feed
      @activities = PublicActivity::Activity.order(created_at: :desc).all
    end
    # keywordを受け取って、amazonで検索する。結果は@resに格納して返し、viewでresの存在をチェックし、
    # 検索結果があるかどうかで表示を切り分け。
    @keyword = params[:keyword]
    if @keyword.present?
      Amazon::Ecs.debug = true
      @res = Amazon::Ecs.item_search(params[:keyword], 
         :search_index => 'All', :response_group => 'Medium' ,:country => 'jp')
      #redirect_to "/studysessions/new/#{current_user.id}/#{session[:room]}"
    else
       #redirect_to root_path
     return
    end
  end
end
