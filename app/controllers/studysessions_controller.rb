class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  before_action :correct_user, only:[:new]
  before_action :have_room, only:[:new,:index]
  #before_action :not_active, only:[:first_step]

  def index
    @ss2=Studysession.realtime_feed(session[:room])
    @active_now=Studysession.find_by(user:current_user.id,active:true)
  end

  def first_step
    session[:user_id]=current_user.id
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    if @active_now.present?
      redirect_to root_path
    end
  end

  def new
     @studysession=Studysession.new
     session[:room]=params[:room]
     @active_now=Studysession.find_by(user:current_user.id,active:true)
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
  
  def create
    @studysession=Studysession.new(studysession_params)
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    if @studysession.save
      redirect_to "/studysessions/studying/#{current_user.id}/#{session[:room]}"
    else
      render 'new'
    end
  end

  def update
    @update=Studysession.find(params[:id])
    @total=User.find(params[:user])
    t=@total.total_time.to_i + params[:time].to_i
    @total.update_attributes(total_time:t)
    @update.update_attributes(active:false,time:params[:time].to_i)
    
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
    def not_active
      redirect_to(root_path) if @active_now
    end
    
end
