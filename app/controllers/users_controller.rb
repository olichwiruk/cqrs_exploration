# frozen_string_literal: true

require 'infrastructure/result_handler'
require 'infrastructure/read_models/users_read_model'
require 'infrastructure/domain/user'
require 'infrastructure/template_renderer'

class UsersController < ApplicationController
  include ResultHandler

  def index
    @users = UsersReadModel.all_users
  end

  def new
    render html: TemplateRenderer.render(
      template: 'app/views/users/new.html.erb',
      view_model: view_model
    ).html_safe
  end

  def edit; end

  def update; end

  def view_model
    @view_model ||= UserRegistrationViewModel.new(
      user: User.new,
      csrf_token: form_authenticity_token
    )
  end

  def update_view_model(**options)
    @view_model = view_model.update(options)
  end

  def create
    result = CreateUserService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end
      handler.on_failure = proc do |errors|
        update_view_model(
          user: User.new(
            name: params[:user][:name],
            email: params[:user][:email]
          ),
          errors: errors
        )
        new
      end
    end
  end
end
