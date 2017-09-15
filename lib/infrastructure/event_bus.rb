# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {
      'order_created' => 'Order::ProcessManagers::OrderProcessManagerRouter',
      'coupon_applied' => 'Order::ProcessManagers::OrderProcessManagerRouter'
    }

    def self.handler(event_name)
      @bus.fetch(event_name).constantize.new if @bus.include?(event_name)
    end
  end
end
