class School < ActiveRecord::Base
  def self.createFromTsv(tsv)
    a = ["a","b","c"]
    CSV.parse(tsv, :col_sep => "\t") do |row|
      School.create(name:row[0],recruit:row[1],percent:row[2],distinction:row[3])
    end
    return a
  end
  def self.getSchoolList()
    return School.all
  end
end
