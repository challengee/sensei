module Sensei
  class Command

    def initialize command
      @command = command
      @parts = command.split(' ')
    end

    def script
      @parts.first
    end

    def arguments
      @parts[1..-1]
    end

    def to_s
      @command
    end
  end
end
