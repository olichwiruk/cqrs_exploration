# frozen_string_literal: true

require 'customer/domain/user'

module Customer
  module Repositories
    class UserRepo < ROM::Repository[:users]
      commands :create, delete: :by_pk
      struct_namespace Customer::Domain

      def by_id(id)
        users.combine(:loyalty_card).by_pk(id).one!
      end

      def all_users
        users.to_a
      end

      def save(user)
        return create(user) if user.id.nil?
        users.by_pk(user.id).command(:update).call(user.to_h)

        save_loyalty_card(user.loyalty_card) if user.loyalty_card
      end

      def available_email?(email)
        users.where(email: email).count.zero?
      end

      def available_email_for_user?(user_id, email)
        users.where(email: email) { id.not(user_id) }.count.zero?
      end

      # @api private
      def save_loyalty_card(loyalty_card)
        if loyalty_card.id.nil?
          loyalty_cards.command(:create).call(loyalty_card)
        else
          loyalty_cards.by_pk(loyalty_card.id).command(:update).call(loyalty_card)
        end
      end
    end
  end
end
