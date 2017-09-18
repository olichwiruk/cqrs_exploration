# frozen_string_literal: true

module Infrastructure
  module Repositories
    class UsersRepository
      extend Infrastructure::Repositories::Repository
      @bounded_context = 'Customer'

      class << self
        # validate
        def available_email?(email)
          !AR::User.exists?(email: email)
        end

        def available_email_for_user?(user_id, email)
          user = AR::User.find_by(email: email)
          user.nil? || user.id.eql?(user_id.to_i)
        end
      end
    end
  end
end
