# frozen_string_literal: true

class OrderDiscounts < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :order
    end
  end
end
