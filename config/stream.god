God.watch do |w|
  w.name            = "stream"
  w.interval        = 5.second
  w.start           = 'ruby ' + File.expand_path(File.dirname(__FILE__) + '/../') + '/script/stream.rb start'

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.running = false
    end
  end

end