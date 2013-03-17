require 'socket'
require 'sensei/sockets'

module Sensei
  class Slave
    include Sockets::NonBlocking

    def initialize command
      @command = command
      @master_location = '/tmp/sensei.socket'
    end

    def execute
      begin
        UNIXSocket.open @master_location do |master|
          master.puts @command

          nonblocking read: [STDIN, master] do |read, write, err|
            if read.include? STDIN
              master.write STDIN.read_nonblock(1024)
            end
            if read.include? master
              print master.read_nonblock(256)
            end
          end while true
        end
      rescue EOFError
        exit
      end
    end
  end
end
