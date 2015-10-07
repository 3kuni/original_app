class StudysessionsController < ApplicationController
  before_action :authenticate_user!  ,only: [:index, :first_step]
  def new
  end

  def index
    @ss2=Studysession.realtime_feed
  end

  def first_step
    
  end

end
