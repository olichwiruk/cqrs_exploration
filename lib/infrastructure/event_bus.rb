# frozen_string_literal: true

Dir["#{Rails.root}/lib/domain/event_handlers/*.rb"].each do |file|
  require file
end

class EventBus
  class << self
    def handler(event_name)
      bus = {
        'user_created' => 'UserCreatedEventHandler',
        'user_updated' => 'UserUpdatedEventHandler'
      }

      bus.fetch(event_name).constantize.new
    end
  end
end
