class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  before_action :correct_user, only:[:new]
  before_action :have_room, only:[:new,:index]
  before_action :not_active, only:[:first_step]

  def index
    @ss2=Studysession.realtime_feed(session[:room])
    @active_now=Studysession.find_by(user:current_user.id,active:true)
  end

  def first_step
    session[:user_id]=current_user.id
    @active_now=Studysession.find_by(user:current_user.id,active:true)
  end

  def new
     @studysession=Studysession.new
     session[:room]=params[:room]
     #@active_now=Studysession.active_now(current_user.id)
  end
  def create
    @studysession=Studysession.new(studysession_params)
    @active_now=Studysession.find_by(user:current_user.id,active:true)
    session[:id]=
    if @studysession.save
      redirect_to "/studysessions/studying/#{current_user.id}/#{session[:room]}"
    else
      render 'new'
    end
  end

  def update
    Studysession.find(params[:id]).update_attributes(active:false)
    redirect_to root_path
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
