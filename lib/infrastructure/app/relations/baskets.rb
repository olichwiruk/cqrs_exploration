# frozen_string_literal: true

class Baskets < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :ordered_product_lines
    end
  end
end
