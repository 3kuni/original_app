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
end
