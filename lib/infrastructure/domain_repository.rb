# frozen_string_literal: true

module Infrastructure
  class DomainRepository
    class << self
      def aggregates
        RequestStore.store[:aggregates]
      end

      def begin
        RequestStore.store[:aggregates] ||= []
      end

      def add(aggregate)
        aggregates << aggregate
        aggregate
      end

      def commit
        aggregates.each do |aggregate|
          while (event = aggregate.applied_events.shift)
            save event
            publish event
          end
        end
      end

      # @api private
      def save(event)
        Infrastructure::WriteRepo.add_event(event)
      end

      # @api private
      def publish(event)
        handler = Infrastructure::EventBus.handler(event.name)
        handler.__send__(event.name, event) unless handler.nil?
      end
    end
  end
end
