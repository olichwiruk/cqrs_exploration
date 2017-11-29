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
        params_validation = validate(params[:user])

        if email_validation.success? && params_validation.success?
          user = Customer::Domain::UserRom.new(
            user_repo.by_id(params[:id])
          )
          user.update(params[:user].permit!.to_h.symbolize_keys)
          user_repo.update(
            params[:id],
            user.instance_values.symbolize_keys
          )
          event_store.commit(user.events)
          M.Right(true)
        else
          params_validation.success? ? email_validation : params_validation
        end
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
