# frozen_string_literal: true

module Order
  module Repositories
    module Read
      class UserRepo < ROM::Repository[:users]
        def by_id(id)
          users.combine(:loyalty_card).by_pk(id).one!
        end
      end
    end
  end
end
