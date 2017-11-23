# frozen_string_literal: true
module Customer
  module Repositories
    class UserRepo < ROM::Repository[:users]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        users.where(id: id).one!
      end
    end
  end
end
