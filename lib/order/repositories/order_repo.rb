# frozen_string_literal: true

require 'order/domain/order'
require 'order/domain/order_line'
require 'order/domain/order_discount'

module Order
  module Repositories
    class OrderRepo < ROM::Repository[:orders]
      commands :create, update: :by_pk
      struct_namespace Order::Domain

      def save(order)
        return create(order) if order.id.nil?
        orders.by_pk(order.id).changeset(:update, order.to_h).commit
        save_order_lines(order.order_lines) if order.order_lines
        save_order_discounts(order) if order.discounts

        order
      end

      def by_id(id)
        orders.combine(:order_lines, :order_discounts).where(id: id).one!
      end

      def by_uuid(uuid)
        orders.combine(:order_lines, :order_discounts).where(uuid: uuid).one!
      end

      def find_current(user_id)
        order = find_last(user_id)
        order unless order&.completed
      end

      def find_last(user_id)
        orders.combine(:order_lines).where(user_id: user_id).order { id.desc }.first
      end

      def find_last_order_lines(user_id)
        find_last(user_id).order_lines
      end

      def first_order?(user_id)
        orders.where(user_id: user_id).to_a.size == 1
      end

      # @api private
      def save_order_lines(lines)
        order_lines.command(:update_collection).call(lines)
      end

      # @api private
      def save_order_discounts(order)
        order_discounts.command(:create, result: :many).call(
          order.discounts.map do |d|
            { order_id: order.id, discount_id: d.id }
          end
        )
      end
    end
  end
end
