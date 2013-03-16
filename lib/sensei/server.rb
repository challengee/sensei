require 'socket'

require 'sockets'

module Sensei
  class Server
    include Sockets::NonBlocking

    # Public: Create a new sensei server.
    #
    # name - Name of the server (and name of the socket).
    def initialize name
      @name = name
      @location = "/tmp/#{name}.socket"
    end

    def start
      # Remove the socket file if there is one.
      File.delete @location

      # Open a new unix domain socket.
      UNIXServer.open @location do |server|
        # Accept sockets (nonblocking).
        nonblocking server do
          # Accept a new socket.
          socket = server.accept_nonblock

          # Attach a Sensei master to this socket.
          # Master.new(socket).handle
        end while true
      end
    end
  end
end
