# frozen_string_literal: true

class Products < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :order_lines
    end
  end
end
