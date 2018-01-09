# frozen_string_literal: true

module Product
  class OrderCheckedOutEventHandler
    attr_reader :event_store, :order_repo, :product_repo

    def initialize(event_store, order_repo, product_repo)
      @event_store = event_store
      @order_repo = order_repo
      @product_repo = product_repo
    end

    def order_checked_out(event)
      order = order_repo.by_uuid(event.aggregate_uuid)
      lines = order.order_lines
      lines.each do |line|
        product = product_repo.by_id(line.product_id)
        product.buy(line.quantity)
        product_repo.update(product)
        event_store.class.aggregate_type
        event_store.commit(product.events)
      end
    end
  end
end
