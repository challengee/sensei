require 'socket'
require 'sensei/sockets'

module Sensei
  class Slave

    def initialize command
      @command = command
      @master_location = '/tmp/sensei.socket'
    end

    def execute
      UNIXSocket.open @master_location do |socket|
        nb_socket = Sockets::NonBlockingSocket.new socket

        output = nb_socket.read
        puts output
      end
    end
  end
end
