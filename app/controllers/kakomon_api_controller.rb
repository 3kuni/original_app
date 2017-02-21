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
end
