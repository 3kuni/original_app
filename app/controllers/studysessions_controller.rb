class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  before_action :correct_user, only:[:new]
  before_action :have_room, only:[:new,:index]
  #before_action :not_active, only:[:first_step]

  def index
    @ss2=Studysession.realtime_feed(session[:room])
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    @current_user=current_user
    @activities = PublicActivity::Activity.all
  end

  def first_step
    session[:user_id]=current_user.id
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    if @active_now.present?
      redirect_to root_path
    end
    @room=Room.all
    @activities = PublicActivity::Activity.all
  end

  def new
    @studysession=Studysession.new
    session[:room]=params[:room]
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    @keyword = params[:keyword]
    @history = Studysession.where(user:current_user.id).uniq.limit(10).pluck(:textbook)
    @activities = PublicActivity::Activity.all
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

  def create
    @studysession=Studysession.new(studysession_params)
    @studysession.update_attributes(starpoint: 27)
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    unless Textbook.find_by(asin:params[:studysession][:textbook])
      res = Amazon::Ecs.item_lookup(params[:studysession][:textbook], :response_group => 'Small, ItemAttributes, Images', :country => 'jp')
      if res.items.first.present?
        Textbook.create(title:res.items.first.get('ItemAttributes/Title'),asin:params[:studysession][:textbook])
      else
        Textbook.create(title:params[:studysession][:textbook])
      end
    end
    @room=Room.find(params[:studysession][:room])
    #update_current_user=@room.current_user
    #Room.find(params[:studysession][:room]).increment(:minutes_total,1)
    @activities = PublicActivity::Activity.all
    if @studysession.save
      @studysession.create_activity :create, owner: current_user
      @room.update_attributes(current_students:@room.current_students.to_i+1)
      redirect_to "/studysessions/studying/#{current_user.id}/#{session[:room]}"
      SessionMailer.session_email(current_user, @studysession).deliver
    else
      render 'new'
    end
  end

  def stop
    @update=Studysession.find(params[:id])
    @total=User.find(params[:user])
    time_minutes=(Time.now.to_i-params[:time].to_i)/60
    t_user=@total.total_time.to_i + time_minutes
    times = @total.times.to_i+1
    

    # STARポイントの計算
    current_points = (time_minutes / 10.to_f).ceil * 13
    session_before_point = @update.starpoint
    user_before_point = @total.starpoint
    # 更新
    @total.update_attributes(total_time:t_user,times:times,
      starpoint: user_before_point + current_points + session_before_point)
    @update.update_attributes(active:false,time:time_minutes,
      starpoint:  current_points + session_before_point)
    @room=Room.find(params[:room])
    t_room=@room.minutes_total.to_i + time_minutes
    @room.update_attributes(minutes_total:t_room)
    unless @room.current_students==0 
      @room.update_attributes(current_students:@room.current_students-1)
    end
    redirect_to root_path
  end

  def edit
    if user_signed_in?
      @studysession=Studysession.find(params[:studysession_id])
      unless @studysession.user==current_user.id
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def update
    @studysession=Studysession.find(params[:id])
    # まだ動かない
    # STARポイントの計算
    stardy_user = User.find_by(id: current_user.id)
    current_points = (params[:studysession][:time].to_i / 10.to_f).ceil * 13
    adjust_points = (@studysession.time / 10.to_f).ceil * 13
    if @studysession.starpoint
      session_before_point = @studysession.starpoint - adjust_points
    else 
      session_before_point = 0
    end
    user_before_point = stardy_user.starpoint - adjust_points
    # 更新
    @studysession.update_attributes(starpoint: session_before_point + current_points)
    stardy_user.update_attributes(starpoint: user_before_point + current_points)
    @studysession.update_attributes(studysession_params)
    redirect_to root_path
  end

  def amazon_index
    @keyword = params[:keyword]
    if @keyword.present?
      Amazon::Ecs.debug = true
      @res = Amazon::Ecs.item_search(params[:keyword], 
          :search_index => 'All', :response_group => 'Medium')
      redirect_to "/studysessions/new/#{current_user.id}/#{session[:room]}"
    else
      # root_path
      return
    end
    @activities = PublicActivity::Activity.all
  end

  def like
      @studysession=Studysession.find(params[:studysession_id])
      @like_from=User.find(current_user.id)
      @studysession.add_evaluation(:stars, 1,@like_from )
      respond_to do |format|
        format.js {@id=params[:studysession_id]}
      end
      #p.reputation_for(:likes).to_i
      #redirect_to (:back)
  end

  def stats
    spl=Time.now.to_s.split("-")
    from = Time.new(spl[0],spl[1],spl[2])
    to = from+1.day-1.second
    @total_minutes_all =Studysession.sum(:time)
    @count_all =Studysession.count
    #@count_daily= Studysession.group("date(created_at)").count
    #@total_minutes_daily= Studysession.group("date(created_at)").sum(:time)
  end

  private
    def studysession_params
      params.require(:studysession).permit(:user,:textbook,:room,:active,:tweet,:time)
    end
    
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def have_room
      redirect_to(root_path) unless params[:room]
    end
    
end
