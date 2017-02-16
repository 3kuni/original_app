require 'json'
class KakomonApiController < ApplicationController
  def showYear
    json = {"status" => "success", "message" => "success create new wcuser"}
    render :json =>  json
  end

end
