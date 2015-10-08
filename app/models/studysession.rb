class Studysession < ActiveRecord::Base
  validates :user     , presence:true
  validates :textbook , presence:true
#  attr_accessor :user, :room, :textbook,:active

#  def initialize(attributes = {})
#    @user  = attributes[:user]
#    @room = attributes[:room]
#    @textbook = attributes[:textbook]
#    @active=attributes[:active]
#  end
  
  
  
  def self.realtime_feed
    where("room = ? and active=?",1,true)
  end

  

end
