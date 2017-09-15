# frozen_string_literal: true

class CreateUserService
  class << self
    M = Dry::Monads
    UsersRepo = Infrastructure::Repositories::UsersRepository

    def call(params)
      email_validation = validate_email(params[:email])
      params_validation = validate(params)

      if email_validation.success? && params_validation.success?
        Infrastructure::DomainRepository.begin
        user = UsersRepo.build(params)
        user.create

        command = Order::Commands::CreateOrderCommand.new(
          user_id: UsersRepo.save(user).id
        )
        result = Infrastructure::CommandBus.send(command)
        Infrastructure::DomainRepository.commit

        email = "To: #{user.email} | Hi #{user.name}! " \
          "Here is your profile: #{command.params[:user_id]}"
        p email if result.success?
      else
        result = params_validation.success? ? email_validation : params_validation
      end

      result
    end

    # @api private
    Validator = Dry::Validation.Form do
      configure do
        config.messages = :i18n

        def email?(value)
          !VALID_EMAIL_REGEX.match(value).nil?
        end

        VALID_EMAIL_REGEX =
          /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      end

      required(:name).filled(:str?)
      required(:email).filled(:str?, :email?)
    end

    # @api private
    def validate(params)
      validator_result = Validator.call(params)
      if validator_result.success?
        M.Right(true)
      else
        M.Left(validator_result.errors)
      end
    end

    # @api private
    def validate_email(email)
      if UsersRepo.available_email?(email)
        M.Right(true)
      else
        M.Left(email: ['email is taken'])
      end
    end
  end
end
