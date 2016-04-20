ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, "config", "environment")

TweetStream.configure do |config|
  config.consumer_key       = ENV['tw_consumer_key'] 
  config.consumer_secret    = ENV['tw_consumer_secret']
  config.oauth_token        = "#{ENV['tw_access_token']}"
  config.oauth_token_secret = ENV['tw_access_token_secret']
  config.auth_method        = :oauth
end
daemon = TweetStream::Daemon.new('stream', :log_output => true)
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
  daemon_logger = Logger.new(File.join(Rails.root, "log", "stream.log"))
  Rails.logger = ActiveRecord::Base.logger = daemon_logger
  Rails.logger.debug "Listening..."
end
daemon.on_error do |message|
  Rails.logger.error message
end
daemon.userstream do |status|
  Rails.logger.debug status.text
  puts "id: #{status.id} #{status.text}"

  if status.text.match(/^@benkyo_stardy.*[\r\n]*.*勉強しよ.*/).present?
    puts "now streaming"
    Twbot.start(status)
  end

  if status.text.match(/^@benkyo_stardy.*[\r\n]*.*勉強おわ.*/).present?
    puts "stop!!"
    Twbot.stop(status)
  end
end

