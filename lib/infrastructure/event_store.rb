# frozen_string_literal: true

module Infrastructure
  class EventStore

    def initialize(write_repo)
      @write_repo = write_repo
    end

    def commit(events)
      while (event = events.shift)
        save event
        publish event
      end
    end

    # @api private
    def save(event)
      @write_repo.create(
        aggregate_type: event.aggregate_type,
        aggregate_uuid: event.aggregate_uuid,
        event_name: event_name(event),
        data: event.values.to_s,
        created_at: Time.now
      )
    end

    # @api private
    def publish(event)
      name = event_name(event)
      handlers = Infrastructure::EventBus.handlers(name)
      return if handlers.nil?

      handlers.each do |handler|
        handler.__send__(name, event)
      end
    end

    # @api private
    def event_name(event)
      event.class.name.demodulize.underscore.to_s.sub(/_event/, '')
    end
  end
end
