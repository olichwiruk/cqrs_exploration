# frozen_string_literal: true

require 'infrastructure/result_handler'
require 'infrastructure/repositories/users_repository'
require 'customer/read_model/user'
require 'infrastructure/template_renderer'

class UsersController < ApplicationController
  include Infrastructure::ResultHandler

  def index
    @users = Infrastructure::Repositories::UsersRepository.all_users
  end

  def new
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/new.html.erb',
      view_model: registration_view_model
    ).html_safe
  end

  def registration_view_model
    @view_model ||= UserRegistrationViewModel.new(
      user: ::User.new,
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = CreateUserService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |errors|
        update_registration_view_model(
          user: ::User.new(
            name: params[:user][:name],
            email: params[:user][:email]
          ),
          csrf_token: form_authenticity_token,
          errors: errors
        )
        new
      end
    end
  end

  def update_registration_view_model(**options)
    @view_model = registration_view_model.update(options)
  end

  def edit
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/edit.html.erb',
      view_model: edition_view_model
    ).html_safe
  end

  def edition_view_model
    @view_model ||= UserRegistrationViewModel.new(
      user: Infrastructure::Repositories::UsersRepository.find(params[:id]),
      csrf_token: form_authenticity_token
    )
  end

  def update
    result = UpdateUserService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |errors|
        update_edition_view_model(
          user: Infrastructure::Repositories::UsersRepository.find(params[:id])
            .update_from_hash(params[:user]),
          csrf_token: form_authenticity_token,
          errors: errors
        )
        edit
      end
    end
  end

  def update_edition_view_model(**options)
    @view_model = edition_view_model.update(options)
  end

  def show; end

  def log
    login_view_model = UserLoginViewModel.new(
      users: Infrastructure::Repositories::UsersRepository.all_users,
      csrf_token: form_authenticity_token
    )

    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/login.html.erb',
      view_model: login_view_model
    ).html_safe
  end

  def login
    session[:user_id] ||= params[:user_id]
    redirect_to users_path
  end

  def logout
    session[:user_id] = nil
    redirect_to users_path
  end
end
