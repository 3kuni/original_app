require 'csv'
class CorrectAnswer < ActiveRecord::Base

  def self.createFromTsv(tsv)
    a = ["a","b","c"]
    CSV.parse(tsv, :col_sep => "\t") do |row|
      #CorrectAnswer.create(year:"2016",enword:row[1],jepercent:row[2],ejpercent:row[3])
      CorrectAnswer.create(year:row[0],subject:row[1],number:row[2],category1:row[3],category2:row[4],
      category3:row[5],category4:row[6],correctAnswer:row[7],image:row[8],point:[9])
    end
    return a
  end
end
