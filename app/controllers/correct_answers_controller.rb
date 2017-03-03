class CorrectAnswersController < ApplicationController
  def show
  end

  def index
  end

  def edit
    @answer = CorrectAnswer.find(params[:id])
  end
end
