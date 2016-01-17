class Stats
require 'twitter'
  def self.hoge
  	spl=Time.now.to_s.split("-")
    from = Time.new(spl[0],spl[1],spl[2])
    to = from+1.day-1.second
    puts from
    puts to
    #total_minutes_all =Studysession.where(user:1,created_at:from..to).sum(:time)
    total_minutes_all =Studysession.sum(:time)
    count_all =Studysession.count
    puts "total: #{(total_minutes_all/60).to_i}時間"
    puts "count: #{count_all}回"
    @count_daily= Studysession.group("date(created_at)").count
    @total_minutes_daily= Studysession.group("date(created_at)").sum(:time)
    #@count_daily.each do |i,n|
    #	puts "#{i} : #{n}回 : #{@total_minutes_daily[i]}時間"
    #end

    # twitter APIの設定
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    # twitter統計
    followers_count = client.user.followers_count
    fav = nil
    query_start = "勉強しよ "
    since_tw = ApplicationController.helpers.time_for_tw(from)
    until_tw = ApplicationController.helpers.time_for_tw(to)
    puts "since:#{since_tw} until:#{until_tw}"
    #result_tweets = client.search(count: 10, result_type: "recent",  exclude: "retweets", since: since_tw, until: until_tw, from: "benkyo_stardy")
    #result_tweets.take(10).each_with_index do |tw, i| 
    #  puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
    #end
    puts "#{client.user.name}フォロワー:#{client.user.followers_count}"
    puts ApplicationController.helpers.time_for_tw(Time.now)
  end
end