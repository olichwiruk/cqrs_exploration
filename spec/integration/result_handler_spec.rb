# frozen_string_literal: true

require 'integration/integration_helper'

describe 'ResultHandler' do
  subject do
    Class.new { include Infrastructure::ResultHandler }
  end

  describe '#handle_op_result' do
    let(:handler) { subject::HandleOpResult::Handler.new }

    context 'when result is successful' do
      def set_on_success
        handler.on_success = 'success'
      end

      it 'runs on_success block' do
        set_on_success
        expect(handler.on_success).to eq('success')
      end
    end

    context 'when result is failure' do
    end
  end
end

# subject.handle_op_result do |handler|
#   handler.on_success = lambda do
#   end
#   handler.on_failure = proc do |validation_result|
#   end
# end
