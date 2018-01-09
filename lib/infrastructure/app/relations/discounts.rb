# frozen_string_literal: true

class Discounts < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :order_discounts
    end
  end
end
