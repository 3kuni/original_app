class Twbot
  require 'twitter'
  Dotenv.load

  def self.search
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )



    f = File.open('./config/twbot_settings.yml', 'r')
    since =f.readlines
    since_start_id = since[0]
    since_stop_id = since[1]
    f.close
    last_update_start=since_start_id
    last_update_stop=since_stop_id
    puts "since_start_id #{since_start_id}"
    puts "since_stop_id #{since_stop_id}"
    query_start = "勉強しよ "
    result_tweets = client.search(query_start, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_start_id, to: "benkyo_stardy")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
      stardy_user = User.find_by(provider:"twitter",name:tw.user.screen_name)
      if stardy_user.present?
        textbook = tw.full_text.match(/@benkyo_stardy[[:blank:]]+勉強しよ[[:blank:]]+(?<text>.+)/)
        if textbook.present?
          textbook = textbook[:text]
        else
          textbook = "勉強"
        end
        @studysession = Studysession.new(user: stardy_user.id, room: "1", textbook: textbook,active:true)
        @studysession.save
        @studysession.create_activity :create, owner: stardy_user
        @room = Room.find(1)
        @room.update_attributes(current_students:@room.current_students.to_i+1)
      end
      client.update("@#{tw.user.screen_name} ふぁいてぃん！(*•̀ᴗ•́*)و ̑̑", in_reply_to_status_id: tw.id) if Rails.env == 'production'
      client.favorite(tw.id) if Rails.env == 'production'
      if i==0 
        last_update_start = tw.id
      end
    end
    query_stop = "勉強おわ "
    result_tweets = client.search(query_stop, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_stop_id, to: "benkyo_stardy")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "STOP: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
      stardy_user = User.find_by(provider:"twitter",name:tw.user.screen_name)
      time_minutes = nil
      if stardy_user.present?
        stardy_active_session = Studysession.find_by(user: stardy_user.id,active: true)
        if stardy_active_session.present?
          puts "Now active!"
          time_minutes=(Time.now.to_i-stardy_active_session.created_at.to_i)/60
          t_user=stardy_user.total_time.to_i + time_minutes
          stardy_user.update_attributes(total_time:t_user)
          stardy_active_session.update_attributes(active:false,time:time_minutes)
          @room=Room.find(stardy_active_session.room)
          t_room=@room.minutes_total.to_i + time_minutes
          @room.update_attributes(minutes_total:t_room)
          unless @room.current_students==0 
            @room.update_attributes(current_students:@room.current_students-1)
          end
        end
      end
      time_minutes = "勉強時間は#{time_minutes}分です！！" if time_minutes.present?
      client.update("@#{tw.user.screen_name} おつかれ〜(๑´ω`ﾉﾉﾞ✧ #{time_minutes}", in_reply_to_status_id: tw.id) if Rails.env == 'production'
      if i==0 
        last_update_stop = tw.id
      end
    end

    f = File.open('./config/twbot_settings.yml', 'w') # wは書き込み権限
    f.puts last_update_start
    #f.puts 686143010174713856
    f.puts last_update_stop
    #f.puts 686142291103203329
    
    f.close
    
  end

end