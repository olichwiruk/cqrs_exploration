# frozen_string_literal: true

class OrderLines < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :order
      belongs_to :products
    end
  end
end
