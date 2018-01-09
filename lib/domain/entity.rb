# frozen_string_literal: true

module Domain
  module Entity
    def applied_events
      @applied_events ||= []
    end

    alias events applied_events

    def attributes
      instance_variable_get(:@fields)
    end

    def apply_event(event)
      do_apply event
      applied_events << event
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
