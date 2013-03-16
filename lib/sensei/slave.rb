require 'socket'
require 'sensei/sockets'

module Sensei
  class Slave

    def initialize command
      @command = command
      @master_location = '/tmp/sensei.socket'
    end

    def execute
      UNIXSocket.open @master_location do |s|
        socket = Sockets::NonBlockingSocket.new s
        socket.puts @command
        until @closed do
          output = socket.read
          if output.empty?
            socket.close
            @closed = true
          else
            puts output
          end
        end
      end
    end
  end
end
