class User < ActiveRecord::Base
  attr_accessor :name
  attr_accessor :email

  def initialize(name, email)
    @name = name
    @email = email
  end
end
