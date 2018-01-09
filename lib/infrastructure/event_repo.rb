# frozen_string_literal: true

module Infrastructure
  class EventRepo < ROM::Repository[:events]
    commands :create

    class << self
      def [](agg_type)
        agg_type_cls_name = agg_type.to_s.camelize
        if const_defined?(agg_type_cls_name, false)
          return const_get(agg_type_cls_name)
        end

        cls = Class.new(self) do
          define_singleton_method(:aggregate_type) do
            agg_type.to_s
          end
        end
        const_set(agg_type_cls_name, cls)

        cls
      end
    end

    def commit(events)
      while (event = events.shift)
        save event
        publish event
      end
    end

    # @api private
    def save(event)
      create(
        aggregate_type: self.class.aggregate_type,
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
