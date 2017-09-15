# frozen_string_literal: true

module Infrastructure
  class WriteRepo
    class << self
      def add_event(event)
        aggregate_type = event.aggregate_type
        aggregate_id = event.aggregate_id
        name = event.name
        data = event.data

        sql = <<-SQL
          insert into write_repo (aggregate_type, aggregate_id, event_name, data, created_at)
          values ('#{aggregate_type}', '#{aggregate_id}', '#{name}', '#{data}', '#{Time.now}')
        SQL

        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
