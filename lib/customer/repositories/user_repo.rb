# frozen_string_literal: true

module Customer
  module Repositories
    class UserRepo < ROM::Repository[:users]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        users.where(id: id).one!
      end

      def available_email?(email)
        users.where(email: email).count.zero?
      end

      def available_email_for_user?(user_id, email)
        users.where(email: email){ id.not(user_id) }.count.zero?
      end
    end
  end
end
