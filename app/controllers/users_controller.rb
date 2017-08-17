require 'infrastructure/domain/user'
require 'infrastructure/command_bus'
require 'infrastructure/commands/create_user_command'

class UsersController < ApplicationController

  def index
    @users = UsersReadModel.all_users
  end

  def new
  end

  def create
    user = User.new(name: params[:user]['name'],
                    email: params[:user]['email'])
    command = CreateUserCommand.new(user)

    if UsersReadModel.check_email(user.email)
      CommandBus::send(command)
    end

    redirect_to users_path
  end

end
