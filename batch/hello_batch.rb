class HelloBatch


	def self.execute
		#puts "this is runner app from batch/ "
		input = "あ ~ お腹空いた 🌀"
		puts input
		input = self.utf8mb4_encode_numericentity(input)
		puts input
	end
	def self.utf8mb4_encode_numericentity(str)
		#str.gsub(/[^\u{0}-\u{FFFF}]/) { '&#x%X;' % $&.ord }
		str.gsub(/[^\u{0}-\u{FFFF}]/, "") 
	end

end


HelloBatch.execute
