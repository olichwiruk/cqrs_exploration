# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = { }

    class << self
      def handlers(event_name)
        return unless @bus.include?(event_name)
        @bus.fetch(event_name).call
      end

      def register_event_handler(name, &block)
        @bus[name] = block
      end

      def finalize
        @bus.freeze
      end
    end
  end
end
