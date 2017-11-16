# frozen_string_literal: true

module Order
  class OrderEventHandler
    OrdersRepo = Infrastructure::Repositories::OrdersRepository
    BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
    OrderProcessesRepo = Infrastructure::Repositories::OrderProcessesRepository
    OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository
    OrderDiscountsRepo = Infrastructure::Repositories::OrderDiscountsRepository
    LoyaltyCardsRepo = Infrastructure::Repositories::LoyaltyCardsRepository

    def order_created(event)
      order = OrdersRepo.build(
        uuid: event.aggregate_uuid,
        params: { user_id: event.user_id }
      )
      OrdersRepo.save(order)
    end

    def discounts_applied(event)
      order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
      event.discounts.each do |d|
        OrderDiscountsRepo.apply(
          order: order,
          discount_id: d.id
        )
      end
    end

    def order_checked_out(event)
      order = OrdersRepo.find_by(uuid: event.aggregate_uuid)

      save_order_lines(order: order)
      update_loyalty_card(order: order)
    end

    # @api private
    def save_order_lines(order:)
      basket = BasketsRepo.find_by(order_id: order.id)
      OrderLinesRepo.save(order, basket.products)
    end

    # @api private
    def update_loyalty_card(order:)
      LoyaltyCardsRepo.save(user_id: order.user_id)
    end
  end
end
