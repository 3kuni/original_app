class UserAnswer < ActiveRecord::Base
  def self.addUserAnswer(list)
    for answer in list
      puts "sent data is #{answer}"
      UserAnswer.create(uuid:answer["uuid"],year:answer["year"],subject:answer["subject"],number:answer["number"],
                        category1:answer["category1"],category2:answer["category2"],category3:answer["category3"],
                        category4:answer["category4"],user_answer:answer["userAnser"],point:answer["point"],
                        total_point:answer["totalPoint"])
    end
    return {"status" => "success", "message" => "success create user_answer"}
  end
end
