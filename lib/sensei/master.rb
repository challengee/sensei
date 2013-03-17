require 'sensei/sockets'
require 'sensei/command'

module Sensei

  # Handles communication and execution for a slave.
  class Master

    def initialize socket
      @slave = socket
    end

    def handle
      command = Command.new @slave.gets
      puts "Executing command: #{command}"

      # # Do the forky thing.
      if child = fork
        # Detach the process.
        Process.detach child

        # Send the PID to the slave for full control.
        # Need control plane here.
        # @slave.puts
      else
        $: << '/usr/bin'

        # This is the child process.
        # Redirect STDOUT and STDERR to the socket.
        [STDOUT, STDERR, STDIN].each do |io|
          io.reopen @slave
        end

        # Set arguments.
        ARGV.replace command.arguments

        # Load the script.
        load command.script

        # We are done here, shut down the socket.
        @slave.shutdown :RDWR
        @slave.close

        # Exit this process.
        exit
      end
    end
  end
end
