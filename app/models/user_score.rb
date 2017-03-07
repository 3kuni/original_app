require 'slack/incoming/webhooks'
class UserScore < ActiveRecord::Base
  def self.addUserScore(data)
    puts data
    UserScore.create(uuid:data["uuid"],year:data["year"],japanese:data["japanese"],english:data["english"],
                    math:data["math"],social:data["social"],science:data["science"],total:data["totalpoint"],
                    school:data["school"],school_id:data["school_id"])
    if data["school"]
      @score = UserScore.where("school is not ? and year = ?", nil,data["year"])
      if (@score.count % 10) == 0
        slack = Slack::Incoming::Webhooks.new "https://hooks.slack.com/services/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"
        dataList = UserScore.calcAverage(data["year"])
        slack.post "#{@score.count}番目のデータが登録されました。\n #{dataList[0]},#{dataList[1].round(1)},#{dataList[2].round(1)}"
      end
    end
    return {"status" => "success", "message" => "success create user_score"}
  end
  def self.average()

  end
  def self.createFromTsv(tsv)
    CSV.parse(tsv, :col_sep => "\t") do |row|
      UserScore.create(uuid:SecureRandom.uuid,year:row[0],japanese:row[1],english:row[2],math:row[3],
      social:row[4],science:row[5],total:row[6],school:row[7],school_id:row[8])
    end
  end
  def self.calcAverage(year)
    # DBからの抽出データ。uuidがダブったデータも含む
    @score = UserScore.where("school is not ? and year = ?", nil,year)

    # 妥当データを格納する変数
    validScore = {}

    # 妥当データの作成
    for answer in @score
      # 妥当性を評価する
      if validScore[answer.uuid]
        puts("already created #{validScore[answer.uuid]["created_at"]} but now compare with #{answer.created_at}")
        # 一番早い日時に登録されたデータのみ格納する
        if validScore[answer.uuid]["created_at"] > answer.created_at
          puts("created:#{validScore[answer.uuid]["created_at"]} is faster than #{answer.created_at}")
          validScore[answer.uuid] = {"japanese" => answer.japanese,
                                        "english" => answer.english,
                                        "math" => answer.math,
                                        "social" => answer.social,
                                        "science" => answer.science,
                                        "total" => answer.total,
                                        "school" => answer.school,
                                        "school_id" => answer.school_id,
                                        "created_at" => answer.created_at}
        end
      else
        # 同じuuidが存在しなかったら格納する
        validScore[answer.uuid] = {"japanese" => answer.japanese,
                                      "english" => answer.english,
                                      "math" => answer.math,
                                      "social" => answer.social,
                                      "science" => answer.science,
                                      "total" => answer.total,
                                      "school" => answer.school,
                                      "school_id" => answer.school_id,
                                      "created_at" => answer.created_at}
      end
    end

    # すべての学校データ
    school_list = School.all

    # 学校毎に算出する平均を格納するハッシュ
    school_average = {}

    # 学校idをキーに、名前、仮平均、割合をハッシュに格納する
    for school in school_list
      total_pro_average = school.distinction.split(",")[2]
      school_average[school.id] = {"name" => school.name,"pro_ave" => total_pro_average, "percent" => school.percent }
    end

    # 全体の仮平均を算出する
    pro_average = 0
    school_average.each {|key,value|
      pro_average += (value["pro_ave"].to_f * value["percent"].to_f) / 100
    }

    # 学校別の平均点を出すための下処理 %>
    school_average.each {|school_key,school_value|
      validScore.each {|key, user|
        if school_key.to_i == user["school_id"].to_i
          #puts("uuid #{key} school_id #{user["school_id"].to_i} schoolname #{user["school"]}")
          if school_value["ave"]
            school_value["ave"] = (school_value["ave"].to_f * school_value["count"] + user["total"]) / (school_value["count"] + 1)
            school_value["count"] += 1
            #puts("average exists #{school_value["name"]} #{school_value["ave"] }")
          else
            school_value["ave"] = user["total"]
            school_value["count"] = 1
            #puts("new #{school_value["name"]} average data")
          end
        end
      }
    }

    # カバレッジを格納する変数
    coverage = 0

    # 算出した最終的な平均点を格納する変数
    average = 0

    # 平均点を算出する
    school_average.each {|key,value|
      # データがあれば代入、なければ仮平均を適用
      if value["ave"]
        processed_average = value["ave"]
        coverage += value["percent"]
      else
        processed_average = value["pro_ave"]
      end

      # 最終的な平均に代入%>
      average += (processed_average.to_f * value["percent"].to_f) / 100
    }
    return [validScore.count,coverage,average]

  end
end
