# frozen_string_literal: true

require 'integration/integration_helper'

describe 'TemplateRenderer' do
  subject do
    Infrastructure::TemplateRenderer
  end

  describe '.render' do
    let(:template) do
      'spec/fixtures/template.erb'
    end

    context 'when view model has attribute' do
      let(:view_model) do
        OpenStruct.new(test_str: 'Test')
      end

      it 'returns html with injected view model' do
        rendered_html = subject.render(
          template: template,
          view_model: view_model
        )

        expect(rendered_html).to match(
          <<~HTML
            <div>
              Test
            </div>
          HTML
        )
      end
    end
  end

  describe '#upload_template' do
    context "when template doesn't exists" do
      let(:template) do
        'wrong/path'
      end

      let(:renderer) do
        subject.new(template: template,
                    view_model: OpenStruct.new)
      end

      it 'raises exception' do
        expect do
          renderer.upload_template
        end.to raise_error(RuntimeError, "File can't be read")
      end
    end
  end
end
