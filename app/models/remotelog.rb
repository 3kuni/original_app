class Remotelog < ActiveRecord::Base
	validates :wordid     , presence:true
	validates :fromto     , presence:true
	validates :correct     , inclusion: {in: [true, false]}
	def self.log(wordid,fromto,correct,userid)
		if self.create(wordid: wordid, fromto:fromto, correct: correct,userid: userid)
			return {"status" => "success", "message" => "remotelog created"}
		else
			return {"status" => "fails", "message" => "failed to craete remotelog"}
		end
	end
end
