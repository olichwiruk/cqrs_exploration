# frozen_string_literal: true

class OrderedProductLines < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :basket
    end
  end
end
