# frozen_string_literal: true

module Customer
  module Services
    class UpdateUserService
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

        user = user_repo.by_id(validation_result.output[:id])
        user.update(validation_result.output[:user])
        user_repo.save(user)

        M.Right(true)
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
          option :user_repo
          predicates(Infrastructure::ValidationPredicates)
        end

        required(:id).filled(:int?)
        required(:user).schema do
          required(:name).filled(:str?)
          required(:email).filled(:str?, :email?)
        end

        validate(available_email_for_user?: %i[id user]) do |id, user|
          user_repo.available_email_for_user?(id, user[:email])
        end
      end
    end
  end
end
