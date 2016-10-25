class Remotelog < ActiveRecord::Base
	validates :wordid     , presence:true
	validates :fromto     , presence:true
	validates :correct     , presence:true
	def self.log(wordid,fromto,correct)
		if self.create(wordid: wordid, fromto:fromto, correct: correct)
			return {"status" => "success", "message" => "remotelog created"}
		else
			return {"status" => "fails", "message" => "failed to craete remotelog"}
		end
	end
end
