# frozen_string_literal: true

module Infrastructure
  module Repositories
    class LoyaltyCardsRepository
      class << self
        def save(user_id:)
          return if AR::LoyaltyCard.exists?(user_id: user_id)
          create(user_id)
        end

        def find_by(user_id:)
          Customer::Domain::LoyaltyCard.new(
            AR::LoyaltyCard.find_by(user_id: user_id)
          )
        end

        # @api private
        def create(user_id)
          AR::LoyaltyCard.create!(user_id: user_id, discount: 1)
        end
      end
    end
  end
end
