require 'json'
class Wcuser < ActiveRecord::Base
	validates :token     , presence:true

	def self.register(uuid:,apptitle:)
		if uuid.downcase.match(/[a-z\d]{8}(-[a-z\d]{4}){3}-[a-z\d]{12}/).present?
			if Wcuser.create(token: uuid, apptitle: apptitle)
				return {"status" => "success", "message" => "success create new wcuser"}
			else
				return {"status" => "failed", "message" => "failed to create new wcuser"}
			end
		else
			return {"status" => "failed", "message" => "uuid doesnt exist"}
		end
	end
	def self.showJson(uuid:,apptitle:)
		if uuid.downcase.match(/[a-z\d]{8}(-[a-z\d]{4}){3}-[a-z\d]{12}/).present?
			return "uuid is #{uuid}, apptitle is #{apptitle}"
		end
	end
	def self.signin(uuid:)
		if self.exists?(:token => uuid)
			return {"status" => "success", "message" => "signed in"}
		else
			return {"status" => "failed", "message" => "failed to sign in"}
		end
	end
end
