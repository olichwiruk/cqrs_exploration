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
          'coupon_applied' => 'Order::EventHandlers::CouponAppliedEventHandler'
        }

        bus.fetch(event_name).constantize.new
      end
    end
  end
end
