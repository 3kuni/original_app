class Praise
  def self.reply
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
          #client.update("@#{stardy_user.name} 3時間超えたので自動終了しました〜編集はここからwww.stardy.co/studysessions/edit/#{i.id}")
          #puts "KILLED @#{stardy_user.name} 3時間超えたので自動終了しました〜"
        end
      elsif (Time.now-i.created_at) > 7200
        stardy_user = User.find_by(provider:"twitter",id:i.user)
        if stardy_user.present?
          stardy_active_session = i
          #client.update("@#{stardy_user.name} 2時間経過٩(ˊᗜˋ*)و ")
          #puts "KILLED @#{stardy_user.name} 3時間超えたので自動終了しました〜"
        end
      elsif (Time.now-i.created_at) > 3600
        stardy_user = User.find_by(provider:"twitter",id:i.user)
        if stardy_user.present?
          stardy_active_session = i
          #client.update("@#{stardy_user.name} 1時間経過(๑′ᴗ‵๑)")
        end
      end
    end
    puts "."
  end
  def self.hoge
    puts "hogeeeeeeeee"
  end

  def self.home
    total_time = 60*199
    new_total_time =60*200
    times = 60

    if   times==1
      puts "おめでとうございます！初めて記録しました！"
    elsif total_time < (60*3) && new_total_time >= (60*3)
      puts "3時間突破！"
    elsif times == 3
      puts "3回目の勉強記録です！この調子で継続できたらいいですね！！"
    elsif total_time < (60*6) && new_total_time >= (60*6)
      puts "勉強記録が6時間を超えました！"
    elsif times == 6
      puts "勉強を記録したのは6回目です！もう慣れてきましたか？？"
    elsif total_time < (60*10) && new_total_time >= (60*10)
      puts "記録が10時間を超えました！すごい！"
    elsif times == 10
      puts "10回目の記録です！習慣になってきましたね！！"
    elsif total_time < (60*30) && new_total_time >= (60*30)
      puts "祝！30時間以上勉強しました！"
    elsif (times/30).integer?
      puts "#{(times/30)*30}回記録しましたー！"
    elsif (total_time/100).floor <= (new_total_time/100).floor
      puts "#{((new_total_time/100)*100)/60}時間を超えました！！"     
    else
      puts "ほめることは特にありません"
    end

  end
end