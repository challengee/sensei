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
      def nonblocking io, &block
        begin
          return yield(io)
        rescue IO::WaitReadable, IO::EINTR
          IO.select [io]
          retry
        end
      end
    end

    # Internal: Provides a reader that reads from
    # any socket in a nonblocking way, but perceived in
    # a blocking way.
    class NonBlockingSocket
      include NonBlocking

      # Wraps a socket as a non-blocking reader.
      #
      # socket - The socket to wrap.
      def initialize socket
        @socket = socket
      end

      # Public: Reads the chunk from the socket.
      #
      # Returns a String.
      def read
        nonblocking @socket do |socket|
          return socket.recv_nonblock(256)
        end
      end
    end
  end
end
