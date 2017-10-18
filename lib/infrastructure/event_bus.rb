# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {
      'order_created' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::OrderCreatedEventDenormalizer'],
      'discount_applied' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::DiscountAppliedEventDenormalizer'],
      'products_added' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::ProductsAddedEventDenormalizer'],
      'order_changed' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::EventDenormalizers::OrderChangedEventDenormalizer'],
      'order_checked_out' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter']
    }

    def self.handlers(event_name)
      return unless @bus.include?(event_name)

      @bus[event_name].map { |e| e.constantize.new }
    end
  end
end
