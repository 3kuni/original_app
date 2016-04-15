class Twbot
  require 'twitter'
  Dotenv.load

  def self.search
    # twitterAPIのセッティング
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    # 設定ファイルの読み込み
    f = File.open('./config/twbot_settings.yml', 'r')
    since =f.readlines
    since_start_id = since[0]
    f.close
    last_update_start=since_start_id
    puts "since_start_id #{since_start_id}"

    # 検索でFF外から
    query_start = "勉強しよ OR 勉強おわ"
    result_tweets_non_follower = client.search(query_start, count: 200, result_type: "recent",  exclude: "retweets", since_id: since_start_id, to: "benkyo_stardy")
    first_search = true
    result_tweets_non_follower.take(200).each do |tw|
      # 検索する最新のidを記録
      if first_search
        last_update_start = tw.id
        first_search = nil
      end

      # 「勉強しよ」の処理
      if tw.full_text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ.*/).present?
        puts "FF外から: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}"
        # 未登録のユーザか判定
        unless User.find_by(name:tw.user.screen_name)
          # 未登録ならゲストユーザとして登録
          User.create!(name: tw.user.screen_name,provider: "guest",uid: User.create_unique_string,
                        nickname: tw.user.screen_name,
                       email: User.create_unique_guest_email,password: User.create_unique_guest_password)
          
          # ツイートからテキスト・つぶやきを取得
          option1 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)(?<text>\S+)(\n|[[:blank:]]*)/)
          option2 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)\S+(\n|[[:blank:]]+)(?<tweet>\S+)/)
          textbook = nil
          tweet = nil
          if option1.present?
            textbook = option1[:text]
            tweet = option2[:tweet] if option2.present?
          else
            textbook = "勉強"
          end

          # ユーザインスタンスを作成、セッションを開始
          guest_user = User.find_by(name: tw.user.screen_name)
          @studysession = Studysession.new(user: guest_user.id, room: "1", textbook: textbook, tweet: tweet,active: true)
          @studysession.save
          @studysession.create_activity :create, owner: guest_user
          @room = Room.find(1)
          @room.update_attributes(current_students:@room.current_students.to_i+1)

          # はじめてのメッセージ
          puts "登録して勉強開始しました！"
          client.update("@#{tw.user.screen_name} はじめての勉強記録です！⁽⁽٩(๑˃̶͈̀ ᗨ ˂̶͈́)۶⁾⁾「勉強おわ」のツイートでここに記録されます！http://www.stardy.co/users/#{guest_user.id}", in_reply_to_status_id: tw.id) if Rails.env == 'production'
          client.favorite(tw.id) if Rails.env == 'production'
          client.retweet(tw.id) if Rails.env == 'production'
        else
          if client.friendship?(client.user(), tw.user)
            puts "exists"
          else
            
            # ツイートからテキスト・つぶやきを取得
            option1 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)(?<text>\S+)(\n|[[:blank:]]*)/)
            option2 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)\S+(\n|[[:blank:]]+)(?<tweet>\S+)/)
            textbook = nil
            tweet = nil
            if option1.present?
              textbook = option1[:text]
              tweet = option2[:tweet] if option2.present?
            else
              textbook = "勉強"
            end

            # ユーザインスタンスを作成、セッションを開始
            stardy_user = User.find_by(name: tw.user.screen_name)
            already_exist = Studysession.find_by(user: stardy_user.id,active: true)
            # セッション中でないことを確認して.save
            unless already_exist.present?
              puts "勉強を開始しました"
              @studysession = Studysession.new(user: stardy_user.id, room: "1", textbook: textbook, tweet: tweet,active: true)
              @studysession.save
              @studysession.create_activity :create, owner: stardy_user
              @room = Room.find(1)
              @room.update_attributes(current_students:@room.current_students.to_i+1)
            end
          end
        end
      end
      # 「勉強おわ」の処理
      if tw.full_text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強おわ.*/).present?
        puts "FF外から「おわ」: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}"
        # 登録済みユーザか判定
        if User.find_by(name:tw.user.screen_name)
          # 登録済みの時
          unless client.friendship?(client.user(), tw.user)
            stardy_user = User.find_by(name:tw.user.screen_name)
            time_minutes = nil
            praise_word = nil
            if stardy_user.present?
              stardy_active_session = Studysession.find_by(user: stardy_user.id,active: true)
              if stardy_active_session.present?
                puts "Now active!"
                # 時間、回数のカウント
                time_minutes=(Time.now.to_i-stardy_active_session.created_at.to_i)/60
                t_user=stardy_user.total_time.to_i + time_minutes
                times = stardy_user.times.to_i + 1
                # User,Studysessionの更新
                stardy_user.update_attributes(total_time:t_user,times: times)
                stardy_active_session.update_attributes(active:false,time:time_minutes)
                # ほめリプ
                if  times==1
                  praise_word = "おめでとうございます！初めて記録しました！"
                elsif stardy_user.total_time.to_i < (60*3) && t_user >= (60*3)
                  praise_word =  "3時間突破！"
                elsif times == 3
                  praise_word =  "3回目の勉強記録です！この調子で継続できたらいいですね！！"
                elsif stardy_user.total_time.to_i < (60*6) && t_user >= (60*6)
                  praise_word =  "勉強記録が6時間を超えました！"
                elsif times == 6
                  praise_word =  "勉強を記録したのは6回目です！もう慣れてきましたか？？"
                elsif stardy_user.total_time.to_i < (60*10) && t_user >= (60*10)
                  praise_word =  "記録が10時間を超えました！すごい！"
                elsif times == 10
                  praise_word =  "10回目の記録です！習慣になってきましたね！！"
                elsif stardy_user.total_time.to_i < (60*30) && t_user >= (60*30)
                  praise_word =  "祝！30時間以上勉強しました！"
                elsif (times/5).to_f.integer?
                  praise_word =  "#{times}回記録しましたー！"
                elsif (stardy_user.total_time.to_i/100).floor < (t_user/100).floor
                  praise_word =  "#{((new_total_time.to_i/100)*100)/60}時間を超えました！！"     
                end

                # Roomの更新
                @room=Room.find(stardy_active_session.room)
                t_room=@room.minutes_total.to_i + time_minutes
                @room.update_attributes(minutes_total:t_room)
                unless @room.current_students==0 
                  @room.update_attributes(current_students:@room.current_students-1)
                end
              end
            end
            puts "おわりましたー"
            time_minutes = "勉強時間は#{time_minutes}分です！！" if time_minutes.present?
            client.update("@#{tw.user.screen_name} #{praise_word}おつかれ〜(๑´ω`ﾉﾉﾞ✧ #{time_minutes}", in_reply_to_status_id: tw.id) if Rails.env == 'production'
          end
        else
          client.update("@#{tw.user.screen_name} 「勉強しよ」とリプを送ってみてください！", in_reply_to_status_id: tw.id) if Rails.env == 'production'
          puts "勉強しよでスタートです"
        end
      end
    end
    sleep(5)


    # STARDYのタイムラインを取得
    result_tweets = client.home_timeline(since_id: since_start_id,count: 200)
    first = true
    result_tweets.take(200).each_with_index do |tw, i| 
      # 「勉強おわ」が本文にあった時の処理
      if tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強おわ.*/).present?
        puts "STOP: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
        stardy_user = User.find_by(provider:"twitter",name:tw.user.screen_name)
        time_minutes = nil
        praise_word = nil
        if stardy_user.present?
          stardy_active_session = Studysession.find_by(user: stardy_user.id,active: true)
          if stardy_active_session.present?
            puts "Now active!"
            # 時間、回数のカウント
            time_minutes=(Time.now.to_i-stardy_active_session.created_at.to_i)/60
            t_user=stardy_user.total_time.to_i + time_minutes
            times = stardy_user.times.to_i + 1
            # User,Studysessionの更新
            stardy_user.update_attributes(total_time:t_user,times: times)
            stardy_active_session.update_attributes(active:false,time:time_minutes)
            # ほめリプ
            if  times==1
              praise_word = "おめでとうございます！初めて記録しました！"
            elsif stardy_user.total_time.to_i < (60*3) && t_user >= (60*3)
              praise_word =  "3時間突破！"
            elsif times == 3
              praise_word =  "3回目の勉強記録です！この調子で継続できたらいいですね！！"
            elsif stardy_user.total_time.to_i < (60*6) && t_user >= (60*6)
              praise_word =  "勉強記録が6時間を超えました！"
            elsif times == 6
              praise_word =  "勉強を記録したのは6回目です！もう慣れてきましたか？？"
            elsif stardy_user.total_time.to_i < (60*10) && t_user >= (60*10)
              praise_word =  "記録が10時間を超えました！すごい！"
            elsif times == 10
              praise_word =  "10回目の記録です！習慣になってきましたね！！"
            elsif stardy_user.total_time.to_i < (60*30) && t_user >= (60*30)
              praise_word =  "祝！30時間以上勉強しました！"
            elsif times % 5 == 0
              praise_word =  "#{times}回記録しましたー！"
            elsif (stardy_user.total_time.to_i/100).floor < (t_user/100).floor
              praise_word =  "#{((new_total_time.to_i/100)*100)/60}時間を超えました！！"     
            end

            # Roomの更新
            @room=Room.find(stardy_active_session.room)
            t_room=@room.minutes_total.to_i + time_minutes
            @room.update_attributes(minutes_total:t_room)
            unless @room.current_students==0 
              @room.update_attributes(current_students:@room.current_students-1)
            end
          end
        end
        time_minutes = "勉強時間は#{time_minutes}分です！！" if time_minutes.present?
        client.update("@#{tw.user.screen_name} #{praise_word}おつかれ〜(๑´ω`ﾉﾉﾞ✧ #{time_minutes}", in_reply_to_status_id: tw.id) if Rails.env == 'production'
        
        if i==0 
          #last_update_stop = tw.id
        end
      end

      # 「勉強しよ」が本文にあった時の処理
      if tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ.*/).present?
        puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
        # ツイートからテキスト・つぶやきを取得
        option1 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)(?<text>\S+)(\n|[[:blank:]]*)/)
        option2 = tw.text.match(/@benkyo_stardy(\n+|[[:blank:]]+)勉強しよ(\n|[[:blank:]]+)\S+(\n|[[:blank:]]+)(?<tweet>\S+)/)
        textbook = nil
        tweet = nil
        if option1.present?
          textbook = option1[:text]
          tweet = option2[:tweet] if option2.present?
        else
          textbook = "勉強"
        end

        # すでに登録済みのユーザかどうか判定
        stardy_user = User.find_by(provider:"twitter",name:tw.user.screen_name)
        if stardy_user.present?
          # 登録済みユーザ
          @studysession = Studysession.new(user: stardy_user.id, room: "1", textbook: textbook, tweet: tweet,active: true)
          already_exist = Studysession.find_by(user: stardy_user.id,active: true)
          # セッション中でないことを確認して.save
          unless already_exist.present?
            @studysession.save
            @studysession.create_activity :create, owner: stardy_user
            @room = Room.find(1)
            @room.update_attributes(current_students:@room.current_students.to_i+1)
          end
          client.update("@#{tw.user.screen_name} ふぁいてぃん！(*•̀ᴗ•́*)و ̑̑", in_reply_to_status_id: tw.id) if Rails.env == 'production'
          client.favorite(tw.id) if Rails.env == 'production'
          client.retweet(tw.id) if Rails.env == 'production'
        end
      end

      if first 
        last_update_start = tw.id if tw.id > last_update_start
        first=nil
        # 設定ファイルの更新
        f = File.open('./config/twbot_settings.yml', 'w') # wは書き込み権限
        f.puts last_update_start
        f.close
      end
    end


  end

  def self.set
    #設定
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )

    f = File.open('./config/twbot_settings.yml', 'r')
    since =f.readlines
    since_start_id = since[0]
    f.close
    last_update_start=since_start_id
    puts "since_start_id #{since_start_id}"

    #セッション開始
    query_start = "勉強しよ "
    result_tweets = client.search(query_start, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_start_id, to: "benkyo_stardy")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "START: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
      if i==0 
        last_update_start = tw.id
      end
    end

    #セッション終了
    query_stop = "勉強おわ "
    result_tweets = client.search(query_stop, count: 10, result_type: "recent",  exclude: "retweets", since_id: since_stop_id, to: "benkyo_stardy")
    result_tweets.take(10).each_with_index do |tw, i| 
      puts "STOP: #{i}: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}" 
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

  def self.test
    #設定
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )
    # 設定ファイルの読み込み
    f = File.open('./config/twbot_settings.yml', 'r')
    since =f.readlines
    since_start_id = since[0]
    f.close
    # 手動で設定
    since_start_id = 720591998600609792
    # FF外からのツイートの処理
    query_start = "勉強しよ OR 勉強おわ"
    result_tweets_non_follower = client.search(query_start, count: 200, result_type: "recent",  exclude: "retweets", since_id: since_start_id, to: "benkyo_stardy")
    result_tweets_non_follower.take(200).each do |tw|
      puts "FF外から: @#{tw.user.screen_name}: #{tw.full_text}: id[#{tw.id}]: #{tw.created_at}"
      # 未登録のユーザか判定
      unless User.find_by(name:tw.user.screen_name)
        if client.friendship?(client.user(), tw.user)
          puts "following"
        else
          puts "not following"
        end
      end
    end
  end

  def self.evening
    # ツイッター設定
    client = Twitter::REST::Client.new(
      consumer_key:        ENV['tw_consumer_key'] ,
      consumer_secret:     ENV['tw_consumer_secret'] ,
      access_token:        "#{ENV['tw_access_token']}",
      access_token_secret: ENV['tw_access_token_secret'],
    )
    client.update("ここに「勉強しよ」とリプすると勉強時間を記録します! #勉強垢さんと繋がりたい")
  end


end