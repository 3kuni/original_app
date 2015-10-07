class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:new]
  def new
  end

  def index
    @ss2=Studysession.realtime_feed
  end

  def first_step
  end
  def last_step
    @textbook=user_session[:textbook]
  end
  def new
    @textbook=user_session[:textbook]
    @studysession=Studysession.new
  end
  def create
    @studysession=Studysession.new(studysession_params)
    if @studysession.save
      redirect_to studysessions_path
    else
      render 'new'
    end
  end

  private
    def studysession_params
      params.require(:studysession).permit(:user,:textbook,:room,:active)
    end
end
