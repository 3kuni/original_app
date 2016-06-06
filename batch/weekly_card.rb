class WeeklyCard
	def self.test
		@weekly_lst = Studysession.where(created_at: (20.weeks.ago)..(Time.now),user: 1).reorder("created_at desc")
		day_index = ""
		@weekly_lst.each do |ss|
			created = ss.created_at
			ss_date = "-- #{created.month}月#{created.day}日"
			puts ss_date unless day_index == ss_date
			day_index = ss_date
			puts ss.textbook
		end

	end
end

WeeklyCard.test