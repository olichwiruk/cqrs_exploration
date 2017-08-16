class User < ActiveRecord::Base
  attr_accessor :name
  attr_accessor :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  class << self
    def create_new_user(user)
      user = User.new(user.name, user.email)
      data = "name: #{user.name}, email: #{user.email}"
      WriteRepo::add_event(Event.new(name: 'create user',
                                     data: data))
    end
  end
end
