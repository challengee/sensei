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
          pid = master.gets.strip.to_i

          Signal.trap 'INT' do
            Process.kill 'KILL', pid
          end

          # Receive STDOUT, STDERR and STDIN.
          [STDOUT, STDERR, STDIN].each do |io|
            master.send_io io
          end

          exit_status = master.gets.strip.to_i
          exit exit_status
        end
      rescue Errno::ECONNREFUSED
        sleep 0.1
        retry
      end
    end
  end
end
