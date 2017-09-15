# frozen_string_literal: true

module Infrastructure
  module Entity
    def applied_events
      @applied_events ||= []
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
      DomainRepository.add(self)
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
  end
end
