class Timeover
  def self.hoge
    @current_active=Studysession.where(active:true)  
    @current_active.each do |i|
      if (Time.now-i.created_at) > 6
        i.update_attributes(active:false)
        current_students=Room.find(i.room).current_students
        Room.find(i.room).update_attributes(current_students:current_students-1)
        puts "faa"
      end
    end
  end
end