class UserScore < ActiveRecord::Base
  def self.addUserScore(data)
    puts data
    UserScore.create(uuid:data["uuid"],year:data["year"],japanese:data["japanese"],english:data["english"],
                    math:data["math"],social:data["social"],science:data["science"],total:data["totalpoint"],
                    school:data["school"],school_id:data["school_id"])
                    
    return {"status" => "success", "message" => "success create user_score"}
  end
  def self.average()

  end
  def self.createFromTsv(tsv)
    CSV.parse(tsv, :col_sep => "\t") do |row|
      UserScore.create(uuid:SecureRandom.uuid,year:row[0],japanese:row[1],english:row[2],math:row[3],
      social:row[4],science:row[5],total:row[6],school:row[7],school_id:row[8])
    end
  end
end
