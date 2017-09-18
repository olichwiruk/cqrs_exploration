# frozen_string_literal: true

module Infrastructure
  module Repositories
    module Repository
      # write
      def save(entity)
        saved = domain_of(entity).new(
          active_record.create!(entity.attributes)
        )
        entity.commit
        saved
      end

      def update(entity)
        domain_of(entity).new(
          active_record.update(entity.id, entity.attributes)
        )
        entity.commit
      end

      # read
      def all
        active_record.all
      end

      def find(id)
        domain.new(
          active_record.find(id)
        )
      end

      def find_by(uuid:)
        domain.new(
          active_record.find_by(uuid: uuid)
        )
      end

      def build(params = {})
        domain.initialize(
          active_record.new(params)
        )
      end

      # @api private
      def domain_of(entity)
        entity.class
      end

      # @api private
      def domain
        "#{@bounded_context}::Domain::#{class_name}".constantize
      end

      # @api private
      def active_record
        "AR::#{class_name}".constantize
      end

      # @api private
      def class_name
        to_s.split('::').last.sub(/Repository/, '').singularize
      end
    end
  end
end
