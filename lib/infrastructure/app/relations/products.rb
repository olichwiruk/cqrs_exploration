# frozen_string_literal: true

class Products < ROM::Relation[:sql]
  schema(infer: true)
end
