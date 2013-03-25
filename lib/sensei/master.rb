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
        Thread.new do
          # Send the PID to the slave for full control.
          @slave.puts child

          Process.wait child
          @slave.puts $?.exitstatus
        end
      else
        $:.push *ENV['PATH'].split(':')

        # Receive STDOUT, STDERR and STDIN.
        [STDOUT, STDERR, STDIN].each do |io|
          io.reopen @slave.recv_io
        end

        # Set arguments.
        ARGV.replace command.arguments

        # Load the script.
        load command.script

        # Exit this process if it has not exited before.
        exit 0
      end
    end
  end
end
