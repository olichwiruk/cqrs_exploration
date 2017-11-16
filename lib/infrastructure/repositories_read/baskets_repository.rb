# frozen_string_literal: true

module Infrastructure
  module RepositoriesRead
    class BasketsRepository
      class << self
        def save(user_uuid)
          AR::Read::Basket.create!(
            user_uuid: user_uuid
          )
        end

        def update(basket)
          AR::Read::Basket.update(
            basket.id,
            basket.attributes
          ).save!
        end

        def find_or_create_by(user_id:)
          build(
            AR::Read::Basket.find_or_create_by(
              user_id: user_id
            )
          )
        end

        def find_by(user_id:)
          build(
            AR::Read::Basket.find_by(
              user_id: user_id
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
