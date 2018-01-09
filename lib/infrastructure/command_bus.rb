# frozen_string_literal: true

module Infrastructure
  class CommandBus
    @bus = { }

    class << self
      def send(command)
        handler = @bus.fetch(command.class.to_s).call
        handler.execute(command)
      end

      def register_command_handler(name, &block)
        @bus[name] = block
      end

      def finalize
        @bus.freeze
      end
    end
  end
end
