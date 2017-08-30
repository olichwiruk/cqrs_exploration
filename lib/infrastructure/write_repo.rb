# frozen_string_literal: true

module Infrastructure
  class WriteRepo
    class << self
      def add_event(event)
        aggregate_uid = event.aggregate_uid
        name = event.name
        data = event.data

        sql = <<-SQL
          insert into write_repo (aggregate_uid, event_name, data, created_at)
          values ('#{aggregate_uid}', '#{name}', '#{data}', '#{Time.now}')
        SQL

        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
