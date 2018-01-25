# frozen_string_literal: true

module Infrastructure
  class EventBus
    def initialize
      @bus = {}
    end

    def register(name, &block)
      @bus[name] = block
    end

    def handlers(event_name)
      return unless @bus.include?(event_name)
      @bus.fetch(event_name).call
    end

    def finalize
      @bus.freeze
    end
  end
end
