# frozen_string_literal: true

require 'integration/integration_helper'

require 'infrastructure/template_renderer'
require 'infrastructure/domain/user'

describe TemplateRenderer do
  subject do
    TemplateRenderer
  end

  describe '.render' do
    template = 'spec/fixtures/template.erb'

    context 'when UserRegistrationViewModel
      is given with plain user' do

      view_model = UserRegistrationViewModel.new(
        user: User.new,
        csrf_token: 'tEstToKen=='
      )

      it 'returns form with correct csrf token' do
        given = subject.render(
          template: template,
          view_model: view_model
        )

        expect(given).to include(
          'value="tEstToKen==" ' \
          'name="authenticity_token" ' \
          'type="hidden"'
        )
      end

      it 'returns plain form' do
        given = subject.render(
          template: template,
          view_model: view_model
        )

        expect(given).to include('id="user_name" value=""')
        expect(given).to include('id="user_email" value=""')
      end
    end

    context 'when UserRegistrationViewModel
      is given with user(Name, email@example.com)' do

      view_model = UserRegistrationViewModel.new(
        user: User.new(
          name: 'Name',
          email: 'email@example.com'
        ),
        csrf_token: ''
      )

      it 'returns filled form' do
        given = subject.render(
          template: template,
          view_model: view_model
        )

        expect(given).to include(
          'id="user_name" value="Name"'
        )
        expect(given).to include(
          'id="user_email" value="email@example.com"'
        )
      end
    end

    context 'when UserRegistrationViewModel contains errors' do
      errors = { name: ['must be filled'],
                 email: ['email invalid'] }
      view_model = UserRegistrationViewModel.new(
        user: User.new(
          name: '',
          email: 'email'
        ),
        csrf_token: '',
        errors: errors
      )
      it 'returns filled form with error messages' do
        given = subject.render(
          template: template,
          view_model: view_model
        )

        expect(given).to include(
          '{:name=>["must be filled"], :email=>["email invalid"]}'
        )
        expect(given).to include(
          'id="user_name" value=""'
        )
        expect(given).to include(
          'id="user_email" value="email"'
        )
      end
    end
  end
end
