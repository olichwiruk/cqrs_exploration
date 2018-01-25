# frozen_string_literal: true

module Infrastructure
  class CommandBus
    def initialize
      @bus = {}
    end

    def register(name, &block)
      @bus[name] = block
    end

    def send(command)
      handler = @bus.fetch(command.class.to_s).call
      handler.execute(command)
    end

    def finalize
      @bus.freeze
    end
  end
end
