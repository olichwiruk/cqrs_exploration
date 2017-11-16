# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {
      'order_created' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter'],

      'products_added' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::OrderViewModelGenerator'],

      'order_changed' =>
      ['Order::OrderViewModelGenerator'],

      'order_checked_out' =>
      ['Order::ProcessManagers::OrderProcessManagerRouter',
       'Order::OrderViewModelGenerator',
       'Product::Services::UpdateWarehouseService']
    }

    def self.handlers(event_name)
      return unless @bus.include?(event_name)

      @bus[event_name].map { |e| e.constantize.new }
    end
  end
end
