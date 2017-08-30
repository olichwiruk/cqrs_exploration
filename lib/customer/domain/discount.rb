# frozen_string_literal: true

module Customer
  module Domain
    class Discount
      attr_reader :aggregate_uid
      attr_reader :value

      class << self
        include Infrastructure::Entity

        def apply_discount(aggregate_uid:, value:)
          apply_event(
            Customer::Events::DiscountAppliedEvent.new(
              aggregate_uid: aggregate_uid,
              value: value
            )
          )
          self
        end

        def on_discount_applied(event); end
      end
    end
  end
end
