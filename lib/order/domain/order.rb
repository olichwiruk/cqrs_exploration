# frozen_string_literal: true

require 'securerandom'

module Order
  module Domain
    class Order
      class << self
        include Infrastructure::Entity

        def create_new_order(user_uid:, discount: 0)
          apply_event(
            Order::Events::OrderCreatedEvent.new(
              aggregate_uid: SecureRandom.uuid,
              user_uid: user_uid,
              discount: discount
            )
          )
        end

        def on_order_created(event); end
      end
    end
  end
end
