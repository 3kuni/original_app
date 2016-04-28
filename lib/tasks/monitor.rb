class Streammonitor
	def self.print
		res = `ps aux | grep stream`.split("\n")
		res.each do |process|
			puts process
		end
	end

	def self.test
		puts "hello"
	end
end
