# frozen_string_literal: true

require 'infrastructure/command_bus'
require 'domain/commands/create_user_command'
require 'infrastructure/result_handler'
require 'infrastructure/repositories/users_read_model'

class CreateUserService
  class << self
    M = Dry::Monads

    def call(params)
      result = validate_email(params[:user][:email])

      if result.success?
        command = CreateUserCommand.new(params[:user])
        result = CommandBus.send(command)
      end

      result
    end

    # @api private
    def validate_email(email)
      if UsersReadModel.available_email?(email)
        M.Right(true)
      else
        M.Left(email: ['email is taken'])
      end
    end
  end
end
