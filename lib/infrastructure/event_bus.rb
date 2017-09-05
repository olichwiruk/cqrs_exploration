# frozen_string_literal: true

Dir["#{Rails.root}/lib/customer/event_handlers/*.rb"].each do |file|
  require file
end

module Infrastructure
  class EventBus
    class << self
      def handler(event_name)
        bus = {
          'user_created' => 'Customer::EventHandlers::UserCreatedEventHandler',
          'user_updated' => 'Customer::EventHandlers::UserUpdatedEventHandler',
          'order_created' => 'Order::ProcessManagers::OrderProcessManagerRouter',
          'coupon_applied' => 'Order::ProcessManagers::OrderProcessManagerRouter'
        }

        bus.fetch(event_name).constantize.new
      end
    end
  end
end
