# frozen_string_literal: true

module Infrastructure
  module Repositories
    class UsersRepository
      class << self
        # write
        def save(user)
          Customer::Domain::User.new(
            AR::User.create!(user.attributes)
          )
        end

        def update(user)
          Customer::Domain::User.new(
            AR::User.update(user.id, user.attributes)
          )
        end

        # read
        def all_users
          AR::User.all
        end

        def find(id)
          Customer::Domain::User.new(
            AR::User.find(id)
          )
        end

        def build(params)
          Customer::Domain::User.new(
            AR::User.new(params)
          )
        end

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
