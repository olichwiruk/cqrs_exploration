class CreateUserCommandHandler

  class << self
    def execute(command)
      validate(command.user)
      user = User.create_new_user(command.user)
      user.commit
    end

    def validate(user)
      if user.name.empty?
        raise "name can't be empty"
      end

      if user.email.empty?
        raise "email can't be empty"
      end

      unless is_a_valid_email?(user.email)
        raise "invalid email"
      end
    end

  private

  VALID_EMAIL_REGEX =
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    def is_a_valid_email?(email)
      email =~ VALID_EMAIL_REGEX
    end

  end
end
