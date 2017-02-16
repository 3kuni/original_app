require 'csv'
class Word < ActiveRecord::Base
	validates :jaword     , presence:true
	validates :enword     , presence:true
	def create
	end

	def self.createFromTsv(tsv)
		a = ["a","b","c"]
		CSV.parse(tsv, :col_sep => "\t") do |row|
  		Word.create(jaword:row[0],enword:row[1],jepercent:row[2],ejpercent:row[3])
		end
		return a
	end
	def self.load(ids)
		words = Word.where(id: ids)
		return {"status" => "success", "message" => "correctly loaded from", "words" => words }
	end
end
