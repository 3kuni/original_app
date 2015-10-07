class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step,:last_step]
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
end
