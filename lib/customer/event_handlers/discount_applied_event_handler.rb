# frozen_string_literal: true

module Customer
  module EventHandlers
    class DiscountAppliedEventHandler
      def discount_applied(event)
        Infrastructure::Repositories::UsersRepository.apply_discount(
          event.aggregate_uid,
          event.data
        )
      end
    end
  end
end
