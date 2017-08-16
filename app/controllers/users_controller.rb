require 'infrastructure/domain/user'
require 'infrastructure/command_bus'
require 'infrastructure/commands/create_user_command'

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
  end

  def create
    user = User.new(params[:user]['name'],
                    params[:user]['email'])
    command = CreateUserCommand.new(user)
    CommandBus::send(command)
  end

end
