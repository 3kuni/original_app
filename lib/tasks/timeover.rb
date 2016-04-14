class Timeover
  def self.kill
    # twitterAPIのセッティング
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    @current_active=Studysession.where(active:true)  
    @current_active.each do |i|
      if (Time.now-i.created_at) > 10800
        i.update_attributes(active:false)
        current_students=Room.find(i.room).current_students
        Room.find(i.room).update_attributes(current_students:current_students-1)
        puts "cron run at #{Time.now}"
        stardy_user = User.find_by(provider:"twitter",id:i.user)
        if stardy_user.present?
          stardy_active_session = i
          client.update("@#{stardy_user.name} 3時間超えたので自動終了しました(・ω・)編集はここからwww.stardy.co/studysessions/edit/#{i.id}")
          #puts "KILLED @#{stardy_user.name} 3時間超えたので自動終了しました〜"
        end
      elsif (Time.now-i.created_at) > 7200
        stardy_user = User.find_by(provider:"twitter",id:i.user)
        if stardy_user.present?
          stardy_active_session = i
          client.update("@#{stardy_user.name} 2時間経過٩(ˊᗜˋ*)و ")
          #puts "KILLED @#{stardy_user.name} 3時間超えたので自動終了しました〜"
        end
      elsif (Time.now-i.created_at) > 3600
        stardy_user = User.find_by(provider:"twitter",id:i.user)
        if stardy_user.present?
          stardy_active_session = i
          client.update("@#{stardy_user.name} 1時間経過(๑′ᴗ‵๑)")
        end
      end
    end
    puts "."
  end
  def self.hoge
    puts "hogeeeeeeeee"
  end
end