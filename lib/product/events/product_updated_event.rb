# frozen_string_literal: true

module Product
  module Events
    class ProductUpdatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String.optional
      attribute :quantity, Infrastructure::Types::Int.optional
      attribute :price, Infrastructure::Types::Int.optional

      def values
        instance_values
          .without('aggregate_uuid', 'aggregate_type')
          .delete_if do |_, v|
          v.nil?
        end
      end
    end
  end
end
