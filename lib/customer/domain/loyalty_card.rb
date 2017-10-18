# frozen_string_literal: true

module Customer
  module Domain
    class LoyaltyCard < Disposable::Twin
      property :id
      property :user_id
      property :discount
    end
  end
end
