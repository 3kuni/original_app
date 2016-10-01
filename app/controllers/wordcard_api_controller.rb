require 'json'
class WordcardApiController < ApplicationController
	def test
		puts "hello"
		json_request = JSON.parse(request.body.read)
    jsonReceived = json_request["glossary"]["array"]
    @personal = {'name' => 'Yamada', 'old' => 28}
    @personal = {'name' =>params[:name],'old' => params[:old]}
    @jsondata = [@personal,{'foo' => 'bar'},{'json' => jsonReceived[1]}]

  	respond_to do |format|
	    format.html{ render :nothing => true }
	    format.json {render :json => @jsondata}
		end
	end

end
