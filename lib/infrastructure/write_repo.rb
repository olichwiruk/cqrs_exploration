# frozen_string_literal: true

module Infrastructure
  class WriteRepo
    class << self
      def commit(events)
        while (event = events.shift)
          save event
          publish event
        end
      end

      # @api private
      def save(event)
        aggregate_type = event.aggregate_type
        aggregate_uuid = event.aggregate_uuid
        name = event_name(event)
        data = event.values

        sql = <<-SQL
          insert into write_repo (aggregate_type, aggregate_uuid, event_name, data, created_at)
          values ('#{aggregate_type}', '#{aggregate_uuid}', '#{name}', '#{data}', '#{Time.now}')
        SQL

        ActiveRecord::Base.connection.execute(sql)
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
end
