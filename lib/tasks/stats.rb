class Stats

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
    @count_daily.each do |i,n|
    	puts "#{i} : #{n}回 : #{@total_minutes_daily[i]}時間"
    end
  end
end