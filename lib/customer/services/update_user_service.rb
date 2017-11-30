# frozen_string_literal: true

module Customer
  module Services
    class UpdateUserService
      M = Dry::Monads
      attr_reader :event_store, :user_repo

      def initialize(event_store, user_repo)
        @event_store = event_store
        @user_repo = user_repo
      end

      def call(params)
        email_validation = validate_email(params[:id], params[:user][:email])
        params_validation_result = Validator.call(params[:user].to_h)
        fail_message = params_validation_result.failure? ? M.Left(params_validation_result.errors) : email_validation

        return fail_message if email_validation.failure? || params_validation_result.failure?

        user = user_repo.by_id(params[:id])
        user.update(params_validation_result.output)

        user_repo.update(params[:id], user.to_h)
        event_store.commit(user.events)

        M.Right(true)
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
      def validate_email(user_id, email)
        if user_repo.available_email_for_user?(user_id, email)
          M.Right(true)
        else
          M.Left(email: ['email is taken'])
        end
      end
    end
  end
end
