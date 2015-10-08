class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  before_action :correct_user, only:[:new]
  before_action :have_room, only:[:new,:index]
  def new
  end

  def index
    @ss2=Studysession.realtime_feed
  end

  def first_step
    session[:user_id]=current_user.id
  end

  def new
     @studysession=Studysession.new
     session[:room]=params[:room]
  end
  def create
    @studysession=Studysession.new(studysession_params)
    if @studysession.save
      redirect_to "/studysessions/studying/#{current_user.id}/#{session[:room]}"
    else
      render 'new'
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

end
