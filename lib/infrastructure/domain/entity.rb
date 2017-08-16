module Entity

  def applied_events
    @applied_events ||= []
  end

  def apply_event(event)
    event_to_store = Event.new(event_name(event),
                               event.instance_values)
    do_apply event
    applied_events << event_to_store
  end

  # @api private
  def do_apply(event)
    method_name = "on_#{event_name(event)}"
    method(method_name).call(event)
  end

  def event_name(event)
    "#{event.class.name.underscore}".sub(/_event/, '')
  end
end
