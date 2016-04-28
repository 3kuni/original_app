class Streammonitor
	
	def self.print
		#ファイルのパスを取得

		# プロセスをチェック
		res = `ps aux | grep stream`.split("\n")
		process_count = 0
		res.each do |process|
			unless process.match(/grep/)
				#puts "found!! #{process}"
				pid = process.split[1]
				puts pid
				if process_count > 0
					`kill -9 #{pid}`
					puts "killed"
				end
				process_count = process_count + 1
			end
		end

		# streamのプロセスがなければ起動
		if process_count == 0 
			puts "No process"
			command = 'ruby ' + File.expand_path(File.dirname(__FILE__) + '/../../' + 'script/stream.rb start')
			`#{command}`
			#{}`ruby /script/stream.rb start`
		end

		# プロセスが2つあったら一つを停止

	end
	
	def self.test
		puts "hello"
	end
end