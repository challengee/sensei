require 'socket'

require 'sensei/sockets'
require 'sensei/master'

module Sensei
  class Server
    include Sockets::NonBlocking

    # Public: Create a new sensei server.
    #
    # name - Name of the server (and name of the socket).
    def initialize name
      @name = name
      @location = "/tmp/#{name}.socket"
      boot
    end

    def start
      # Remove the socket file if there is one.
      File.delete @location if File.exists? @location

      # Open a new unix domain socket.
      UNIXServer.open @location do |server|
        # Accept sockets (nonblocking).
        nonblocking read: [server] do
          puts 'attempt server'
          # Accept a new socket.
          socket = server.accept_nonblock

          puts "got socket #{socket}"

          # Attach a Sensei master to this socket.
          Master.new(socket).handle
        end while true
      end
    end

    private

    def boot
      require './config/environment'
      puts "Booted"
    end
  end
end
