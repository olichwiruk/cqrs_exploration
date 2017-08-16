class User < ActiveRecord::Base
  include Entity

  attr_accessor :name
  attr_accessor :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  class << self
    def create_new_user(cmd_user)
      user = User.new(cmd_user.name, cmd_user.email)
      data = "name: #{user.name}, email: #{user.email}"
      WriteRepo::add_event(Event.new(name: 'create user',
                                     data: data))
    end
  end
end
