# frozen_string_literal: true

module Customer
  module Services
    class CreateUserService
      def initialize(event_store, user_repo)
        @event_store = event_store
        @user_repo = user_repo
      end

      M = Dry::Monads
      UsersRepo = Infrastructure::Repositories::UsersRepository

      def call(params)
        email_validation = validate_email(params[:email])
        params_validation = validate(params)

        if email_validation.success? && params_validation.success?
          user = Customer::Domain::UserRom.initialize(
            params.to_h.symbolize_keys
          )
          @user_repo.create(user.instance_values.symbolize_keys)
          @event_store.commit(user.events)

          # command = Order::Commands::CreateOrderCommand.new(
          #   user_id: saved_user.id
          # )
          # result = Infrastructure::CommandBus.send(command)

          send_email(saved_user) # if result.success?
          M.Right(true) # result
        else
          params_validation.success? ? email_validation : params_validation
        end
      end

      # @api private
      def send_email(user)
        p "To: #{user.email} | #{user.name} - #{user.id}"
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
end
