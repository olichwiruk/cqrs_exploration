# frozen_string_literal: true

class UsersController < ApplicationController
  include Infrastructure::ResultHandler

  attr_reader :user_repo, :users_service

  def initialize(user_repo, users_service)
    @user_repo = user_repo
    @users_service = users_service
    super()
  end

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/index.html.erb',
      view_model: User::UsersListViewModel.new(
        users: user_repo.all_users,
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
    @view_model ||= User::UserRegistrationViewModel.new(
      user: Customer::ReadModels::User.new,
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = users_service.create_user.call(params[:user])

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |validation_result|
        update_registration_view_model(
          user: Customer::ReadModels::User.new(params[:user].to_h),
          csrf_token: form_authenticity_token,
          errors: validation_result.errors
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
    @view_model ||= User::UserRegistrationViewModel.new(
      user: Customer::ReadModels::User.new(
        user_repo.by_id(params[:id])
      ),
      csrf_token: form_authenticity_token
    )
  end

  def update
    result = users_service.update_user.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to users_path
      end

      handler.on_failure = proc do |validation_result|
        update_edition_view_model(
          user: Customer::ReadModels::User.new(
            params[:user].merge(id: params[:id]).to_h
          ),
          csrf_token: form_authenticity_token,
          errors: validation_result.errors
        )
        edit
      end
    end
  end

  def update_edition_view_model(**options)
    @view_model = edition_view_model.update(options)
  end

  def login_view
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/users/login.html.erb',
      view_model: User::UserLoginViewModel.new(
        users: user_repo.all_users,
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
