# frozen_string_literal: true

class LoyaltyCards < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :user
    end
  end
end
