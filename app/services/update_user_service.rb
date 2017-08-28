# frozen_string_literal: true

class UpdateUserService
  class << self
    M = Dry::Monads

    def call(params)
      result = validate_email(params[:id], params[:user][:email])

      if result.success?
        diff = differences(
          params[:user],
          UsersReadModel.find(params[:id])
        )
        return M.Left(error: ['no changes']) if diff.empty?

        command = UpdateUserCommand.new(
          diff.merge(uid: params[:user][:uid])
        )
        result = CommandBus.send(command)
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

    # api private
    def differences(params, read_model)
      changes = read_model.update_from_hash(params).instance_variable_get('@_changes')
      params.select do |k, _|
        changes[k]
      end
    end
  end
end
