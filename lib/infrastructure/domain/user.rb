require 'infrastructure/domain/entity'
require 'infrastructure/events/user_created_event'
require 'securerandom'

class User < ActiveRecord::Base
  include Entity

  attr_accessor :name
  attr_accessor :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  class << self
    include Entity

    def create_new_user(cmd_user)
      user = User.new(cmd_user.name, cmd_user.email)
      user.apply_event(UserCreatedEvent.new(aggregate_uid:
                                       SecureRandom.uuid,
                                       name: user.name,
                                       email: user.email))
      user
    end
  end

  def on_user_created(event)
  end
end
