# frozen_string_literal: true

require 'read_model/user'

class CreateUserCommandHandler
  M = Dry::Monads

  class << self
    def execute(command)
      validation_result = command.validate

      return M.Left(validation_result.errors) unless validation_result.success?

      user = ReadModel::User.create_new_user(validation_result.output)
      user.commit

      M.Right(user)
    end
  end
end
