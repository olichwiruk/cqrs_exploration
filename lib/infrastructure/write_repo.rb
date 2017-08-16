class WriteRepo

  class << self

    def add_event(event)
      name = event.name
      data = event.data

      sql = <<-SQL
        insert into write_repo (event_name, data)
        values ('#{ name }', '#{ data }')
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
