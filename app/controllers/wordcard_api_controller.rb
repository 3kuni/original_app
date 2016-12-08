require 'json'
class WordcardApiController < ApplicationController
	def register
		json_request = JSON.parse(request.body.read)
		uuid = json_request["uuid"]
		apptitle = json_request["apptitle"]
		json =  Wcuser.register(uuid:uuid,apptitle:apptitle)
		render :json =>  json
	end
	def signin
		json_request = JSON.parse(request.body.read)
		uuid = json_request["uuid"]
		json = Wcuser.signin(uuid:uuid) 
		render :json => json
	end
	def load
		json_request = JSON.parse(request.body.read)
		ids = json_request["ids"]
		json = Word.load(ids)
		render :json => json
	end
	def remotelog
		json_request = JSON.parse(request.body.read)
		wordid = json_request["wordid"]
		fromto = json_request["fromto"]
		correct = json_request["correct"]
		userid = json_request["userid"]
		json = Remotelog.log(wordid, fromto, correct,userid)
		render :json => json
	end

=begin
	def test
		json_request = JSON.parse(request.body.read)
    jsonReceived = json_request["aiu"]
    @personal = {'name' => 'Yamada', 'old' => 28}
    @personal = {'name' =>params[:name],'old' => params[:old]}
    @jsondata = {'json' => jsonReceived, 'foo' => 'bar'}

  	respond_to do |format|
	    format.html{ render :nothing => true }
	    format.json {render :json => @jsondata}
		end
	end
=end
end
