# frozen_string_literal: true

module Customer
  module Services
    class CreateUserService
      M = Dry::Monads
      attr_reader :event_store, :user_repo

      def initialize(event_store, user_repo)
        @event_store = event_store
        @user_repo = user_repo
      end

      def call(params)
        email_validation = validate_email(params[:email])
        params_validation_result = Validator.call(params.to_h)
        fail_message = params_validation_result.failure? ? M.Left(params_validation_result.errors) : email_validation

        return fail_message if email_validation.failure? || params_validation_result.failure?

        user = Customer::Domain::User.initialize(
          params_validation_result.output
        )

        saved_user = user_repo.create(user.to_h)
        event_store.commit(user.events)

        send_email(saved_user)
        M.Right(true)
      end

      # @api private
      def send_email(user)
        p "To: #{user.email} | #{user.name} - #{user.id}"
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
          predicates(Infrastructure::ValidationPredicates)
        end

        required(:name).filled(:str?)
        required(:email).filled(:str?, :email?)
      end

      # @api private
      def validate_email(email)
        if user_repo.available_email?(email)
          M.Right(true)
        else
          M.Left(email: ['email is taken'])
        end
      end
    end
  end
end
