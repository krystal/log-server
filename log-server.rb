#!/usr/bin/env ruby
require 'socket'
require 'stringio'
require 'logger'
require 'fileutils'

loggers = {}
server = UDPSocket.new
server.bind('0.0.0.0', 4455)

loop do
  raw_data, sender_addrinfo = server.recvfrom(100000)
  data = StringIO.new(raw_data)
  data.seek(0)
  sender = sender_addrinfo[3]
  
  l = data.read(2).unpack('n')[0]
  app_name = data.read(l)
  l = data.read(2).unpack('n')[0]
  log_name = data.read(l)
  
  full_log_name = File.join(app_name, log_name + '.log')
  log_path = File.join(File.expand_path('../logs', __FILE__), full_log_name)
  FileUtils.mkdir_p(File.dirname(log_path))
  unless logger = loggers[full_log_name]
    logger = loggers[full_log_name] = Logger.new(log_path, 10, 1024000)
    logger.formatter = proc { |_,_,_,msg| msg + "\n" }
  end

  loop do
    line_length = data.read(2).unpack('n')[0]
    break if line_length == 0
    data.read(line_length).split("\n").each do |l|
      logger.info "[#{sender}] #{l}"
    end
  end
end
