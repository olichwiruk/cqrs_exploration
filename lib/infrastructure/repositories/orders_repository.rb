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

        def apply_coupon_to_order(order_id, value)
          sql = <<-SQL
            update orders
            set discount = discount + #{value}, updated_at = '#{Time.now}'
            where uid = '#{order_id}'
          SQL

          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
