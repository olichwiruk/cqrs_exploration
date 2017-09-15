# frozen_string_literal: true

module Product
  module Domain
    class Product < Disposable::Twin
      include Infrastructure::Entity

      property :id
      property :uuid
      property :name
      property :quantity

      def attributes
        instance_variable_get(:@fields)
      end
    end
  end
end
