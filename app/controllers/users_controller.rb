# frozen_string_literal: true

class UsersController < ApplicationController
  include Infrastructure::ResultHandler
  UsersRepo = Infrastructure::Repositories::UsersRepository

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/index.html.erb',
      view_model: Users::UsersListViewModel.new(
        users: UsersRepo.all,
        current_user_id: session[:user_id]
      )
    ).html_safe
  end

  def new
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/new.html.erb',
      view_model: registration_view_model
    ).html_safe
  end

  def registration_view_model
    @view_model ||= Users::UserRegistrationViewModel.new(
      user: Customer::ReadModels::User.new,
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = Customer::Services::CreateUserService.call(params[:user].permit!)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |errors|
        update_registration_view_model(
          user: Customer::ReadModels::User.new(
            params[:user]
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
    @view_model ||= Users::UserRegistrationViewModel.new(
      user: Customer::ReadModels::User.new(
        AR::User.find(params[:id]).attributes
      ),
      csrf_token: form_authenticity_token
    )
  end

  def update
    result = Customer::Services::UpdateUserService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |errors|
        update_edition_view_model(
          user: Customer::ReadModels::User.new(
            params[:user].merge(id: params[:id]).permit!
          ),
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

  def login_view
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/login.html.erb',
      view_model: Users::UserLoginViewModel.new(
        users: UsersRepo.all,
        csrf_token: form_authenticity_token
      )
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
