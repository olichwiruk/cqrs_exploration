# frozen_string_literal: true

module Customer
  module Services
    class CreateUserService
      M = Dry::Monads
      attr_reader :user_repo

      def initialize(user_repo)
        @user_repo = user_repo
      end

      def call(params)
        validation_result = Validator
          .with(user_repo: user_repo)
          .call(params.to_h)

        return M.Left(validation_result) if validation_result.failure?

        user = Customer::Domain::User.initialize(
          validation_result.output
        )

        saved_user = user_repo.save(user)

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
          option :user_repo
          predicates(Infrastructure::ValidationPredicates)

          def available_email?(email)
            user_repo.available_email?(email)
          end
        end

        required(:name).filled(:str?)
        required(:email).filled(:str?, :email?, :available_email?)
      end
    end
  end
end
