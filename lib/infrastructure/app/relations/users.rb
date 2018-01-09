# frozen_string_literal: true

class Users < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_one :loyalty_card
    end
  end
end
