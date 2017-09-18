# frozen_string_literal: true

module Customer
  module Services
    class UpdateUserService
      class << self
        M = Dry::Monads
        UsersRepo = Infrastructure::Repositories::UsersRepository

        def call(params)
          email_validation = validate_email(params[:id], params[:user][:email])
          params_validation = validate(params[:user])

          if email_validation.success? && params_validation.success?
            user = UsersRepo.find(params[:id])
            user.update(params[:user])
            UsersRepo.update(user)
            M.Right(true)
          else
            params_validation.success? ? email_validation : params_validation
          end
        end

        # @api private
        def validate_email(user_id, email)
          if UsersRepo.available_email_for_user?(user_id, email)
            M.Right(true)
          else
            M.Left(email: ['email is taken'])
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
      end
    end
  end
end
