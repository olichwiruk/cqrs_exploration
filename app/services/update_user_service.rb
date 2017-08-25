# frozen_string_literal: true

class UpdateUserService
  class << self
    M = Dry::Monads

    def call(params)
      result = validate_email(params[:id], params[:user][:email])

      if result.success?
        # send UpdateUserCommand to CommandBus
      end

      result
    end

    # @api private
    def validate_email(user_id, email)
      if UsersReadModel.available_email_for_user?(user_id, email)
        M.Right(true)
      else
        M.Left(email: ['email is taken'])
      end
    end
  end
end
