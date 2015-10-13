class Studysession < ActiveRecord::Base
  validates :user     , presence:true
  validates :textbook , presence:true
  default_scope -> { order('updated_at DESC') }
#  attr_accessor :user, :room, :textbook, :active

#  def initialize(attributes = {})
#    @user  = attributes[:user]
#    @room = attributes[:room]
#    @textbook = attributes[:textbook]
#    @active=attributes[:active]
#  end
  
  
  
  def self.realtime_feed(room)
    where("room = ? and active=?", room, true)
  end

  # 与えられたユーザーがフォローしているユーザー達のセッションを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user"
    where("user IN (#{followed_user_ids}) OR user = :user",
          user: user.id)
  end

end
