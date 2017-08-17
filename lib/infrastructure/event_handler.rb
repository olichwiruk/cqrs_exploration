module EventHandler

  def on(*events, &block)
    events.each do |event_name|
      super(event_name) do |event|
        event.data = event.data.to_hash.symbolize_keys
        block.call(event)
      end
    end
  end

end
