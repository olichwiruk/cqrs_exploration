# frozen_string_literal: true

module Infrastructure
  module Entity
    def applied_events
      @applied_events ||= []
    end

    def attributes
      instance_variable_get(:@fields)
    end

    def apply_event(event)
      event_to_store = Infrastructure::Event.new(
        aggregate_type: event.aggregate_type,
        name: event_name(event),
        aggregate_id: event.aggregate_id,
        data: event.values
      )
      do_apply event
      applied_events << event_to_store
    end

    def commit
      while (event = applied_events.shift)
        save event
        publish event
      end
    end

    # @api private
    def do_apply(event)
      method_name = "on_#{event_name(event)}"
      method(method_name).call(event)
    end

    # @api private
    def event_name(event)
      event.class.name.demodulize.underscore.to_s.sub(/_event/, '')
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
