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
        #puts "stardy_nickname: #{stardy_user.nickname},#{stardy_user.area},#{stardy_user.grade},#{stardy_user.word}"
        @studysession=Studysession.new(user: stardy_user.id, room: "1", textbook: "勉強")
        @studysession.save
      end
      #client.update("@#{tw.user.screen_name} ふぁいてぃん！", in_reply_to_status_id: tw.id)
      if i==0 
        last_update_start = tw.id
      end
    end
    query_stop = "勉強おわ "
    result_tweets = client.search(query_stop, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_stop_id, to: "benkyo_stardy")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "STOP: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
      stardy_user = User.find_by(provider:"twitter",name:tw.user.screen_name)
      if stardy_user.present?

      end
      client.update("@#{tw.user.screen_name} おつかれ〜", in_reply_to_status_id: tw.id)
      if i==0 
        last_update_stop = tw.id
      end
    end

    f = File.open('./config/twbot_settings.yml', 'w') # wは書き込み権限
    f.puts last_update_start
    f.puts last_update_stop
    f.close
    
  end

end