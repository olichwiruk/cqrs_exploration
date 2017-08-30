# frozen_string_literal: true

module Infrastructure
  module ResultHandler
    def handle_op_result(result:, &block)
      HandleOpResult.call(result: result, &block)
    end

    class HandleOpResult
      def self.call(result:, handler: Handler.new)
        yield(handler)
        if result.success?
          handler.on_success.call
        else
          handler.on_failure.call(result.value)
        end
      end

      class Handler
        attr_accessor :on_success, :on_failure
      end
    end
  end
end
