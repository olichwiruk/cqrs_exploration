# frozen_string_literal: true

require 'infrastructure/result_handler'
require 'infrastructure/read_models/users_read_model'

class UsersController < ApplicationController
  include ResultHandler

  def index
    @users = UsersReadModel.all_users
  end

  def new; end

  def edit; end

  def update; end

  def create
    result = CreateUserService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end
      handler.on_failure = proc do |errors|
        redirect_to users_path, flash: { errors: errors }
      end
    end
  end
end
