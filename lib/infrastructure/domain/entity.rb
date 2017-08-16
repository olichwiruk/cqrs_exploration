require 'infrastructure/event'
require 'infrastructure/write_repo'

module Entity

  def applied_events
    @applied_events ||= []
  end

  def apply_event(event)
    values = event.instance_values
    event_to_store = Event.new({name: event_name(event),
                                aggregate_uid: values.delete('aggregate_uid'),
                                data: values })
    do_apply event
    applied_events << event_to_store
  end

  def commit
    applied_events.each do |event|
      save event
      publish event
    end
  end

  # @api private
  def do_apply(event)
    method_name = "on_#{event_name(event)}"
    method(method_name).call(event)
  end

  def save(event)
    WriteRepo::add_event(event)
  end

  def publish(event)
    #todo
  end

  def event_name(event)
    "#{event.class.name.underscore}".sub(/_event/, '')
  end
end
