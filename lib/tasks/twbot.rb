class Twbot
  require 'twitter'

  def self.search
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        ENV['tw_access_token'],
      access_token_secret: ENV['tw_access_token_secret'],
    )
  
    query = "勉強しよ "
    since_id = nil
    result_tweets = client.search(query, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_id, to: "stardyjp")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "#{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
      client.update("@#{tw.user.screen_name} ふぁいてぃん！", in_reply_to_status_id: tw.id)
    end
    #puts result_tweets
    #client.update("@_3kuni ファイト～", in_reply_to_status_id: 684367796742955008)
  end

  def self.kill
    @current_active=Studysession.where(active:true)  
    @current_active.each do |i|
      if (Time.now-i.created_at) > 10800
        i.update_attributes(active:false)
        current_students=Room.find(i.room).current_students
        Room.find(i.room).update_attributes(current_students:current_students-1)
        puts "cron run at #{Time.now}"
      end
    end
    puts "."
  end
  def self.hoge
    puts "hogeeeeeeeee"
  end
end