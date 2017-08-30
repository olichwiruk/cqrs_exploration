# frozen_string_literal: true

require 'infrastructure/command_bus'
require 'customer/commands/create_user_command'
require 'infrastructure/repositories/users_repository'

class CreateUserService
  class << self
    M = Dry::Monads

    def call(params)
      result = validate_email(params[:user][:email])

      if result.success?
        command = Customer::Commands::CreateUserCommand.new(params[:user])
        result = Infrastructure::CommandBus.send(command)
      end

      result
    end

    # @api private
    def validate_email(email)
      if Infrastructure::Repositories::UsersRepository.available_email?(email)
        M.Right(true)
      else
        M.Left(email: ['email is taken'])
      end
    end
  end
end
