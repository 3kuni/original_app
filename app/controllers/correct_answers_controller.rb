class CorrectAnswersController < ApplicationController
  def show
  end

  def index
  end

  def edit
    @answer = CorrectAnswer.find(params[:id])
  end
  def update
    @answer = CorrectAnswer.find(params[:id])
    puts "output #{@answer} #{answer_params}"
    if @answer.update_attributes(answer_params)
      # 更新に成功
      puts "success update"
      render 'index'
    end

  end
  def destroy
    @answer = CorrectAnswer.find(params[:id])
    if @answer.destroy
      render 'index'
    end
  end

  private
    def answer_params
      params.require(:correct_answer).permit(:correctAnswer, :image, :point)
    end
end
