class Studysession < ActiveRecord::Base
  validates :user     , presence:true
  validates :textbook , presence:true

  def self.realtime_feed
    where("room = ? and active=?",1,true)
  end

  def self.itsme?(string)
    string == string.reverse
  end

  def existance
  end

  def self.hello    # 引数のないメソッド。
    self =="Hello, world!"
  end

end
