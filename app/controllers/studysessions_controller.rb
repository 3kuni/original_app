class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  before_action :correct_user, only:[:new]
  before_action :have_room, only:[:new,:index]
  #before_action :not_active, only:[:first_step]

  def index
    @ss2=Studysession.realtime_feed(session[:room])
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    @current_user=current_user
  end

  def first_step
    session[:user_id]=current_user.id
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    if @active_now.present?
      redirect_to root_path
    end
    @room=Room.all
  end

  def new
     @studysession=Studysession.new
     session[:room]=params[:room]
     @active_now=Studysession.find_by(user:current_user.id,active:true)
     @keyword = params[:keyword]
     #@history = Studysession.where(user:current_user.id).limit(5)
     @history = Studysession.where(user:current_user.id).uniq.limit(10).pluck(:textbook)
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
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    unless Textbook.find_by(asin:params[:studysession][:textbook])
      res = Amazon::Ecs.item_lookup(params[:studysession][:textbook], :response_group => 'Small, ItemAttributes, Images', :country => 'jp')
      if res.items.first.present?
        Textbook.create(title:res.items.first.get('ItemAttributes/Title'),asin:params[:studysession][:textbook])
      end
    end
    
    #Room.find(params[:studysession][:room]).increment(:minutes_total,1)
    if @studysession.save
      redirect_to "/studysessions/studying/#{current_user.id}/#{session[:room]}"
    else
      render 'new'
    end
  end

  def update
    @update=Studysession.find(params[:id])
    @total=User.find(params[:user])
    time_minutes=(Time.now.to_i-params[:time].to_i)/60
    t_user=@total.total_time.to_i + time_minutes
    @total.update_attributes(total_time:t_user)
    @update.update_attributes(active:false,time:time_minutes)
    @room=Room.find(params[:room])
    t_room=@room.minutes_total.to_i + time_minutes
    @room.update_attributes(minutes_total:t_room)
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

  private
    def studysession_params
      params.require(:studysession).permit(:user,:textbook,:room,:active)
    end
    
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def have_room
      redirect_to(root_path) unless params[:room]
    end
    
end
