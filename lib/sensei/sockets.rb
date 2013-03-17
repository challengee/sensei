require 'delegate'

module Sensei

  # Internal: A Collection of useful socket tools.
  module Sockets
    module NonBlocking

      # Internal: Provides an environment where all calls
      # to nonblocking io are perceived as blocking.
      #
      # Whenever data is not available yet, the system
      # selects on the source untill new data is available,
      # then the provided block is re-executed.
      #
      # io - The IO object to do some nonblocking io on.
      #
      # Yields the io object.
      def nonblocking ios, &block
        begin
          yield(IO.select(ios[:read], ios[:write], ios[:err]))
        rescue IO::WaitReadable, Errno::EINTR
          retry
        end
      end
    end

    # Internal: Provides a reader that reads from
    # any socket in a nonblocking way, but perceived in
    # a blocking way.
    class NonBlockingSocket < SimpleDelegator
      include NonBlocking

      # Wraps a socket as a non-blocking reader.
      #
      # socket - The socket to wrap.
      def initialize socket
        super
        @socket = socket
      end

      # Public: Reads the chunk from the socket.
      #
      # Returns a String.
      def read
        nonblocking @socket do |socket|
          return socket.recv_nonblock(1024)
        end
      end
    end
  end
end
