class Feed
  require 'twitter'
  Dotenv.load
  require 'net/http'
  require 'uri'
  require 'json'

  def self.search
    # twitterAPIのセッティング
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    # ツイッターから30分以内に「勉強しよ」とつぶやいた人を検索
    before_onehour = 30.minutes.ago.to_s.match(/(\S+)[[:blank:]](\S+)[[:blank:]](\S+)/)
    before_onehour = before_onehour[1] + "_" + before_onehour[2] + "_JST"
    query_start = "勉強しよ since:#{before_onehour}"
    result_tweets = client.search(query_start, count: 100, result_type: "recent",  exclude: "retweets")
    puts "結果: #{result_tweets.count}件"
    tweets_embed = []
    result_tweets.take(10).each_with_index do |tw, i| 
      uri = URI.parse('https://api.twitter.com/1/statuses/oembed.json?id=' + tw.id.to_s + '&lang=ja')
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      tweets_embed[i] = result["html"]
      puts tweets_embed[i]
      puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
    end
  end

  def self.json
    uri = URI.parse('https://api.twitter.com/1/statuses/oembed.json?id=319648428621692928&lang=ja')
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    #puts result
    puts result["html"]
  end

end