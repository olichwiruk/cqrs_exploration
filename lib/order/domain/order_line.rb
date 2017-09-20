# frozen_string_literal: true

module Order
  module Domain
    class OrderLine < Disposable::Twin
      property :order_id
      property :product_id
      property :quantity
    end
  end
end
