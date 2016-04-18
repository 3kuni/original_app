module ApplicationHelper
  require 'net/http'
  require 'uri'
  require 'json'
  require 'twitter'
  # 字数制限をつける
  # 引数 =>
  # text:カットしたい対象の文字列
  # len:字数
  
  def cut_off(text, len)
    if text != nil
      if text.length < len
        text
      else
        text.insert(len/2, "<br>")
        text.scan(/^.{#{len+3}}/m)[0] + "…"

      end
    else
      ''
    end
  end

  def feed_from_tw
      # twitterAPIのセッティング
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    # ツイッターから30分以内に「勉強しよ」とつぶやいた人を検索
    #before_onehour = 30.minutes.ago.to_s.match(/(\S+)[[:blank:]](\S+)[[:blank:]](\S+)/)
    #before_onehour = before_onehour[1] + "_" + before_onehour[2] + "_JST"
    before_onehour = time_for_tw(30.minutes.ago)
    query_start = "勉強しよ since:#{before_onehour}"
  #result_tweets = client.search(query_start, count: 100, result_type: "recent",  exclude: "retweets")
  #puts "結果: #{result_tweets.count}件"
    tweets_embed = [] #
    #result_tweets.take(10).each_with_index do |tw, i| 
    #  puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}"
    #end 
  #search_res= "<span style=\"font-size:3rem\">#{result_tweets.count}</span>人が<br>「勉強しよ」と言っています！(直近30分)" 
  #return [search_res.html_safe ,result_tweets] #
  end

  def time_for_tw(time)
    time = time.to_s.match(/(\S+)[[:blank:]](\S+)[[:blank:]](\S+)/)
    formatted = time[1] + "_" + time[2] + "_JST"
  end

end
