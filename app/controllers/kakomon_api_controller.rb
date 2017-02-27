require 'json'
class KakomonApiController < ApplicationController
  def showYear
    # 表示する年度を返す。
    json = {"status" => "success", "message" => "success get year",
            "data" => [{"year"=>"2017","visible" => false},{"year"=>"2016","visible" => true}]}
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
    render 'index'
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
  def schoolindex
  end
end
