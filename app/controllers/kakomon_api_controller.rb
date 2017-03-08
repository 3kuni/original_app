require 'json'
class KakomonApiController < ApplicationController
  def showYear
    # 表示する年度を返す。
    json = {"status" => "success", "message" => "success get year",
            "data" => [{"year"=>"平成29","visible" => true},{"year"=>"平成28","visible" => true},{"year"=>"平成27","visible" => true}]}
    render :json =>  json
  end
  def getCorrectAnswer
    json_request = JSON.parse(request.body.read)
    json = CorrectAnswer.loadAnswers(year:json_request["year"],subject:json_request["subject"])
    render :json => json
  end
  def batch
  end
  def tsv
    tsv = params[:q]
    data = CorrectAnswer.createFromTsv(tsv)
    render template: "correct_answers/index"
  end
  def index
  end
  def userAnswer
    json_request = JSON.parse(request.body.read)
    json = UserAnswer.addUserAnswer(json_request["data"])
    render :json => json
  end
  def answers
  end
  def userScore
    json_request = JSON.parse(request.body.read)
    json = UserScore.addUserScore(json_request)
    render :json => json
  end
  def scores
  end
  def regi_school
  end
  def regischool_tsv
    tsv = params[:q]
    School.createFromTsv(tsv)
    render 'schoolindex'
  end
  def school_list
    json = School.getSchoolList
    render :json => json
  end
  def show_average
    UserScore.average()
    render 'show_average'
  end
  def newdummy
  end
  def create_dummy_tsv
    tsv = params[:q]
    UserScore.createFromTsv(tsv)
    render 'show_average'
  end
  def delete_score
    UserScore.find(params[:id]).destroy
    render :nothing => true
  end
end
