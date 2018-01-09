# frozen_string_literal: true

module Customer
  module Services
    class UsersService
      attr_reader :create_user, :update_user

      def initialize(create_user, update_user)
        @create_user = create_user
        @update_user = update_user
      end
    end
  end
end
