lst = Studysession.all
# Studysessionにポイントを付与
lst.each do |session|
	if session.time
		session.update_attributes(starpoint: (session.time / 10.to_f).ceil * 13 + 27) 
	else
		session.update_attributes(starpoint: 27)
	end
end



# 集計してUserにポイント付与
userlst = User.all
userlst.each do |user|
	# Userのポイントを一度０に
	unless user.starpoint
		user.update_attributes(starpoint: 0)
	end
	sessionLst = Studysession.where(user: user.id)
	sessionLst.each do |session|
		before = user.starpoint
		user.update_attributes(starpoint: before + session.starpoint)
	end
end
