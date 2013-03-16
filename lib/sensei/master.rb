require 'sensei/sockets'
require 'sensei/command'

module Sensei

  # Handles communication and execution for a slave.
  class Master

    def initialize socket
      @socket = Sockets::NonBlockingSocket.new socket
    end

    def handle
      command = Command.new @socket.read

      # Do the forky thing.
      if fork.nil?
        # This is the child process.
        # Redirect STDOUT to the socket.
        $stdout = @socket

        # Load the script.
        load command.script

        # We are done here, shut down the socket.
        # @socket.shutdown :RDWR

        # Exit this process.
        exit
      end
    end
  end
end
