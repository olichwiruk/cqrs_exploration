# frozen_string_literal: true
module Disposable
  class Twin
    def update_from_hash(hash, element = self)
      h = hash.dup
      h.each do |key, value|
        case value.class.to_s
        when 'Array'
          CollectionElement.new(element: element, params: value, node_name: key).call
        when /\AHash(WithIndifferentAccess)?\Z/
          HashElement.new(element: element, params: value, node_name: key).call
        else
          AttributeElement.new(element: element, params: value, node_name: key).call
        end
      end
      element
    end

    class CreateOrUpdateElement
      attr_reader :element, :params, :node_name, :node_resolver

      def initialize(element:, params:, node_name:, node_resolver: ARResolver.new)
        @params = params
        @element = element
        @node_name = node_name
        @node_resolver = node_resolver
      end
    end

    class AttributeElement < CreateOrUpdateElement
      def call
        return unless element.respond_to?(node_name)

        element.__send__("#{node_name}=", params)
      end
    end

    class HashElement < CreateOrUpdateElement
      def call
        unless element.__send__(node_name)
          element.__send__("#{node_name}=", nested_node)
        end

        element.update_from_hash(
          params,
          element.__send__(node_name)
        )
      end

      # @api private
      def nested_node
        @nested_node ||=
          node_resolver.call(element, node_name).new
      end
    end

    class CollectionElement < CreateOrUpdateElement
      def call
        return unless element.respond_to?("#{node_name}=")

        elements_to_be_created
        elements_to_be_updated
        elements_to_be_deleted
      end

      # @api private
      def collection
        @collection ||= element.__send__(node_name)
      end

      # @api private
      def elements_to_be_deleted
        (collection - elements_to_be_created - elements_to_be_updated).each do |e|
          collection.destroy(e)
        end
      end

      # @api private
      def elements_to_be_created
        @elements_to_be_created ||=
          params
          .select { |fragment| fragment[:id].nil? }
          .collect do |fragment|
            model = node_resolver.call(element, node_name)

            twin = collection.insert(collection.count, model.new)
            element.update_from_hash(fragment, twin)

            twin
          end
      end

      # @api private
      def elements_to_be_updated
        return [] unless element.respond_to?(node_name)

        @elements_to_be_updated ||=
          collection.each_with_object([]) do |e, memo|
            params.each do |fragment|
              next if !e.respond_to?(:id) || e.id != fragment[:id].to_i
              element.update_from_hash(fragment, e)

              memo << e
            end
          end
      end
    end

    class ARResolver
      def call(element, association_name)
        (element.respond_to?(:model) ? element.model : element)
          .class
          .reflect_on_association(association_name).klass
      end
    end
  end
end
