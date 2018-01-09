# frozen_string_literal: true

module Domain
  class SchemaStruct < ROM::Struct
    constructor_type :schema
    T = Infrastructure::Types
  end
end
