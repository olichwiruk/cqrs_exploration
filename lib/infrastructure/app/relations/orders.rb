# frozen_string_literal: true

class Orders < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :order_lines
      has_many :order_discounts
    end
  end
end
