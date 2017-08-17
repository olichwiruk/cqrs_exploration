require 'infrastructure/domain/entity'
require 'infrastructure/events/user_created_event'
require 'securerandom'

class User
  include Entity

  attr_accessor :name
  attr_accessor :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  class << self
    include Entity

    def create_new_user(cmd_user)
      user = User.new(name: cmd_user.name,
                      email: cmd_user.email)
      user.apply_event(UserCreatedEvent.new(aggregate_uid:
                                       SecureRandom.uuid,
                                       name: user.name,
                                       email: user.email))
      user
    end
  end

  def on_user_created(event)
    @uid = event.aggregate_uid
  end
end
