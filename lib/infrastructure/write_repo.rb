# frozen_string_literal: true

module Infrastructure
  class WriteRepo
    class << self
      def add_event(event)
        aggregate_type = event.aggregate_type
        aggregate_uuid = event.aggregate_uuid
        name = event.name
        data = event.data

        sql = <<-SQL
          insert into write_repo (aggregate_type, aggregate_uuid, event_name, data, created_at)
          values ('#{aggregate_type}', '#{aggregate_uuid}', '#{name}', '#{data}', '#{Time.now}')
        SQL

        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
