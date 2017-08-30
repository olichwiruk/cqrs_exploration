# frozen_string_literal: true

require 'infrastructure/command_bus'
require 'infrastructure/repositories/users_repository'
require 'customer/commands/update_user_command'

class UpdateUserService
  class << self
    M = Dry::Monads

    def call(params)
      result = validate_email(params[:id], params[:user][:email])

      if result.success?
        diff = differences(
          params[:user],
          Infrastructure::Repositories::UsersRepository.find(params[:id])
        )
        return M.Left(error: ['no changes']) if diff.empty?

        command = Customer::Commands::UpdateUserCommand.new(
          diff.merge(uid: params[:user][:uid])
        )
        result = Infrastructure::CommandBus.send(command)
      end

      result
    end

    # @api private
    def validate_email(user_id, email)
      if Infrastructure::Repositories::UsersRepository
          .available_email_for_user?(user_id, email)
        M.Right(true)
      else
        M.Left(email: ['email is taken'])
      end
    end

    # api private
    def differences(params, read_model)
      changes = read_model.update_from_hash(params).instance_variable_get('@_changes')
      params.select do |k, _|
        changes[k]
      end
    end
  end
end
