# frozen_string_literal: true

module Product
  class OrderCheckedOutEventHandler
    attr_reader :order_repo, :product_repo

    def initialize(order_repo, product_repo)
      @order_repo = order_repo
      @product_repo = product_repo
    end

    def order_checked_out(event)
      order = order_repo.by_uuid(event.aggregate_uuid)
      lines = order.order_lines
      products = product_repo.by_ids(lines.map(&:product_id))
      lines.each do |line|
        product = products.find { |p| p.id == line.product_id }
        product.buy(line.quantity)
        product_repo.save(product)
      end
    end
  end
end
