# frozen_string_literal: true

module Infrastructure
  module RepositoriesRead
    class BasketsRepository
      class << self
        def save(order_id)
          AR::Read::Basket.create!(
            order_id: order_id,
            discount: 0
          )
        end

        def update(basket)
          AR::Read::Basket.update(
            basket.id,
            basket.attributes
          ).save!
        end

        def find_or_create_by(order_id:)
          build(
            AR::Read::Basket.find_or_create_by(
              order_id: order_id
            )
          )
        end

        def find_by(order_id:)
          build(
            AR::Read::Basket.find_by(
              order_id: order_id
            )
          )
        end

        def build(ar)
          Order::Domain::Read::Basket.initialize(ar)
        end
      end
    end
  end
end
