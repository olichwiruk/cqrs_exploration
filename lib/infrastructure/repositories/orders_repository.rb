# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrdersRepository
      class << self
        def add_order(uid, order)
          user_uid = order['user_uid']

          sql = <<-SQL
            insert into orders (uid, user_uid, created_at, updated_at)
            values ('#{uid}', '#{user_uid}', '#{Time.now}', '#{Time.now}')
          SQL

          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
