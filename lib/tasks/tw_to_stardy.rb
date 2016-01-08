class TwToStardy

  def self.hoge
    puts "hogeeeeeeeee"
    @studysession=Studysession.new(user: "1",room: "2", textbook: "勉強")
    @studysession.save
  end
end