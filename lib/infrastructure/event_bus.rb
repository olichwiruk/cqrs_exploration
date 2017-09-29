# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {
      'order_created' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::OrderCreatedEventDenormalizer'],
      'coupon_applied' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::CouponAppliedEventDenormalizer'],
      'products_added' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::ProductsAddedEventDenormalizer'],
      'order_changed' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::OrderChangedEventDenormalizer']
    }

    def self.handlers(event_name)
      return unless @bus.include?(event_name)

      @bus[event_name].map { |e| e.constantize.new }
    end
  end
end
